Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060957;
	b=jmLzII2p/XyFt2WXEVDas1Nzz28pk8QzVMrQDIfi0F1mXSsbjiJx+X+o4/33+MjjE1wW
	 M/XykjgO3Wm/fyHbM/nTZa97xCY7XRBDrlaZzkOEWHkNS67mfQzwo+VvpV1zd+0RStoWR
	 HrK1B1QqzLPKyF4TtwV9TKUq6uRTn9zlssEyc9SeomExriPLOKfievUY956TzI8/frjZx
	 wLXHRXpvDwlL/Dz7D0CFRIgYFySbVIoD6pbyS7wLFuP5yUxSe+GYdpoDbCpaMu9VTCfRW
	 DEY6W3QVY9dQTouFgU25g8h1kK3l+uEoAQOsOJyCHKgznq2Unt6l1K3NLqenqdIE8fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iuWUAnBGjDIcNniP0MYzXnG5p9ecg/2zmapJ7UXkhhk=;
	b=uwGoIOkc9+W/wfQhLaoSF+FRl27i8RL90SUXxBbrFF92iVt+aNLsx1kY76Z5M+hmlqmf
	 8wXTrVFfc8/eIReg4cD+RRWyDJj1m+8Fdhzb6HBiTOasEvBdJi38+2M03NCv0vnYzqqCM
	 kxeqz0OTZff76LRyJqLQ085s5EIa8qgcJYiIddohM6o5DX2B0p5nfi5HWBVgFnGXDJk1i
	 m65RN8+5sMmlwCKp6/0LV7ESZ1GpjyYtkAso/Xj4teEizoACpB/YVnFDSvfm+G4y2+du7
	 p7B1S9ZT4BRLC0reOHuC0X4J++FjDA6hEsg2Quq9DSRC6j+5bP9TQnUqZhwlkLXkg7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNQAAbmP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CAA606D80C;
	Sat,  7 Nov 2026 14:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNQAAbmP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBB71F0089F;
	Sat,  7 Nov 2026 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060956;
	bh=iuWUAnBGjDIcNniP0MYzXnG5p9ecg/2zmapJ7UXkhhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNQAAbmPL2UBhxsVUQQKj33KucboHAam9kWYOInKCaoLBM9d/cqkOCZNVEoIEnAO6
	 mzvpzlhSmNPPYfD+0y122kTiQgGOw53Q27OA0vvIcRKYgc2DKBo+Jl9WvO2rG4o/4i
	 N81B84vv7JF7eWNMqh6JI224qDMz0iwrTT6uPdv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0314/1536] apparmor: fix auditing of mount binary data
Date: Sat,  7 Nov 2026 08:38:50 -0500
Message-ID: <20261107135006.541018217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit b9f2181b90ec047488dcb4fb1c631d417aff07e0 ]

AppArmor only mediates non-binary mount data, and should only
audit the mount data if it is non-binary.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index bf8863253e072..ae65923b90105 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -345,8 +345,8 @@ static int match_mnt_path_str(const struct cred *subj_cred,
 
 audit:
 	return audit_mount(subj_cred, profile, OP_MOUNT, mntpnt, devname,
-			   type, NULL,
-			   flags, data, AA_MAY_MOUNT, &perms, info, error);
+			   type, NULL, flags, !binary ? data : NULL,
+			   AA_MAY_MOUNT, &perms, info, error);
 }
 
 /**
-- 
2.53.0



