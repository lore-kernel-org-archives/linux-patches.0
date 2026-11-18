Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052613;
	b=y7DVInTWv46AaYH1LGu6ZUEm3fNAvufbyWlL85u1/7Dc/YYYBbrr9lDOJYtH7IXQrp4A
	 G0sU5LT/uGem9WuqX9K/r/eoat+ZRRnfclN026oDJDduhRpEQUq3ByhQ/254dwndVAfs3
	 TvloIqsCRVnV52sWCUgRmOJXkbQfPbmQ1fhYGU/jBF4ajc7HdK42F4JSkGPwWfx8KOnDb
	 xyyGTesMVUqt1dW3TkYyDP21u+KL/11P3gRz4aUE7U+K/sHXm3soHNBq1tYOod1tH/iRl
	 qz6DozkDRd68j3IlltBUXvcycxks7cR1nZtl/sIVND6/zAjSgFTlmXoRNWqrIhU2GAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=URhpOOIPQj1pGxKfwOprX97C15JriI8s9NPIQGVigho=;
	b=DmKIii4dOSxzb2kx5S6i6YsPqiTfl8BJTd4u6tzAh8butnd/7tPIHhwXc8CBjHaJt/t3
	 Hop3Lar5Aclx7MeeiK20DC37laxwdQPN6zilIg2VjkVYtg2ANZvDLrSBPKnV3o1OQDUlq
	 qjsHMn1bd7ury0tFQ42o4ifMkexXQ7j9ClclH7NofGTZFYZMwF8he33NoCxDXW/KruT/L
	 9xbDbNj0qLj3sAOD3QvSR+Nol624uIKD8BYHV8GlgVUtHz+GDGjhwcEZ+Wzn9rbI8MLed
	 aWgzIR9q+vlRInD1zDCCrbF5b9nvP+tkfHFO/WM5VhhMijxnA+tEOC3kZTpSY9J2bhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFXo09ES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A5D606A31C;
	Thu, 19 Nov 2026 01:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFXo09ES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE8B1F000C4;
	Thu, 19 Nov 2026 01:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052613;
	bh=URhpOOIPQj1pGxKfwOprX97C15JriI8s9NPIQGVigho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFXo09ESA3CpPmL5PGCKrlWmmDTBUgEhE1tsQ6qHW5DzQcI7ia2mwNPJ+24Lm6xy/
	 A4OF6vHwK+tnnADB6jo35UpzQKL8hKBBPJi9teuV8cmNyMRAzvfM9UU+sQkZcCLhNK
	 QkUYsgDqtrRdCIVKZ5hnLx4XV55zdwJjCOkIxFcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0579/2214] floppy: return the drive state flags from the 32-bit FDGETDRVSTAT
Date: Wed, 18 Nov 2026 15:37:35 +0100
Message-ID: <20261118150034.097427523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov (Oracle) <efremov@linux.com>

[ Upstream commit bb38473f1bcb287567f2fa7980e483a778092504 ]

compat_getdrvstat() copies every field of the drive state to a 32-bit
caller except ->flags, which stays zero. 32-bit FDGETDRVSTAT and
FDPOLLDRVSTAT therefore never report FD_DISK_WRITABLE, FD_DISK_CHANGED
or FD_VERIFY: i386 fdutils (floppycontrol -P, fdmount), and other
32-bit users see every disk as write-protected and never see a disk
change. The compat code in block/compat_ioctl.c copied the field;
it was lost when that code moved into floppy.c

Also declare the field as compat_ulong_t: the 32-bit struct
floppy_drive_struct starts with an unsigned long, and a signed char at
offset 0 only lines up with its low byte on little-endian machines. The
size and offsets of the compat structure, and so FDGETDRVSTAT32, do not
change.

Cc: stable@vger.kernel.org
Fixes: 229b53c9bf4e ("take floppy compat ioctls to sodding floppy.c")
Link: https://patch.msgid.link/20260924112825.3525931-1-efremov@linux.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index f08607f69645a..f4c55a9a9534c 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3603,7 +3603,7 @@ struct compat_floppy_drive_params {
 };
 
 struct compat_floppy_drive_struct {
-	signed char	flags;
+	compat_ulong_t	flags;
 	compat_ulong_t	spinup_date;
 	compat_ulong_t	select_date;
 	compat_ulong_t	first_read_date;
@@ -3787,6 +3787,7 @@ static int compat_getdrvstat(int drive, bool poll,
 			goto Eintr;
 		process_fd_request();
 	}
+	v.flags = drive_state[drive].flags;
 	v.spinup_date = drive_state[drive].spinup_date;
 	v.select_date = drive_state[drive].select_date;
 	v.first_read_date = drive_state[drive].first_read_date;
-- 
2.53.0



