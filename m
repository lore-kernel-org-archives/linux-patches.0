Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622886;
	b=QJjzpu18GBEwJLK+evzXpnZWFahOOLq4czPh/IZGVPdkQ2jxFKB87GfIGnBjaSoc3ASs
	 3nVtdTjmtDfIOCJik2Fquv0Qdr0Nf14hbOzDWP64IiEjvoVzHDfkH1W8L8Z3+SzmaLcNs
	 y43cWtiyBhQ30wuIYQRleUj9zPnc1Gv/t4S/ZXj0nF8RYbFgsK01mPEA/yt8KIr5gkB6s
	 UsdD7TYaSbdD35nGPksnivF4RvQuKmS7rIpMlWCXtqkkO1/7h3OV7OtEjT0LrNLILG0/O
	 S/NArH1J8rPSaGzXYq1Tkl925qsGg1LPBdL2eJHlH/R37wCM+nx6BQkNYV63WUTJOug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lRue6xf5Z0KAwT/xAN/3YTaz/0MB5l9GM95/kD69BSE=;
	b=TZFafZAutidUqS4RKBDOxT4RHe3zuY60TurBk6bgisMdV3/zKI7rbnpH09mHqwpTSbqA
	 g9/DKLuNDkzETT3pcjcrY+Y8p4GQ0X43EAnQ2bADJgLJ9EriEPkrVS6JYUv3F5ejfwqPh
	 LF4rq6bvVbjpuyFzsyQ+FgyP0sul8zoXJJwwiyZ7UGU5+7UUtWq6FGWwI0pMGlcD2iwBU
	 bGyfpA5ItBupRl/Hgovy89rTPSYyRZeJ3YMB0lp0jlblM2yYdyZ4vaNMF5z+i7VmjDc2n
	 D7ISgP/r+Hcc4b3OrLJPmXg2LJ3yCq59XCLKcgakUOVw9VEB1XvQpQQKDz0ppci7aQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbZ6kSyG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B0C606A327;
	Wed, 25 Nov 2026 16:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbZ6kSyG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6EE1F000C0;
	Wed, 25 Nov 2026 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622885;
	bh=lRue6xf5Z0KAwT/xAN/3YTaz/0MB5l9GM95/kD69BSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbZ6kSyG5kOrqrkZ3K8bNqZx+VluKanuURSVMMwNQAHSDUM+e8aGV6CmizjAnQzfu
	 qnJKiWddN0cyD49/O82puhx6W/NdSz+OtUQBVM40YM1NhCQ07ieBCF0RhqHtC3ABkq
	 t13OH6ajnHmg+ROEuEa+zfKhiKYROM2yBGR323c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Luca Boccassi <luca.boccassi@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 644/990] pidfs: do not report fields that do not fit into the callers struct
Date: Wed, 25 Nov 2026 15:33:31 +0100
Message-ID: <20261125143837.176174845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 1534c37167488f2b85c74de048e1d6a4ba3848de ]

The documentation of struct pidfd_info promises that "If the structure
size is too small to contain a field (requested or not), to avoid
confusion the mask will not contain a bit for that field", and asks
userspace to trust the returned mask when deciding which fields hold
valid data.

pidfd_info() does not keep that promise. It builds kinfo.mask without
looking at the size encoded in the ioctl command, and
copy_struct_to_user() then truncates the copy to that size. A caller
that passes a 64-byte struct (PIDFD_INFO_SIZE_VER0) and requests
PIDFD_INFO_COREDUMP or PIDFD_INFO_SUPPORTED_MASK gets a mask with
PIDFD_INFO_COREDUMP, PIDFD_INFO_COREDUMP_SIGNAL, PIDFD_INFO_COREDUMP_CODE
and PIDFD_INFO_SUPPORTED_MASK set, while the coredump_* and
supported_mask fields behind the 64 bytes were never written. Trusting
the mask as documented, userspace then reads whatever its own buffer
held at those offsets. The same happens for a 72- or 80-byte struct
and the fields added after it.

Clear the bits of the fields that lie beyond the caller's size before
the copy, in the one place that knows both the final mask and the size.
A request for a field that cannot be returned is thereby answered the
way the header describes: the field is simply absent from the mask.

Fixes: 1d8db6fd698d ("pidfs, coredump: add PIDFD_INFO_COREDUMP")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261024041334.831273-2-nickolai@csail.mit.edu
Acked-by: Luca Boccassi <luca.boccassi@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Dropped the COREDUMP_SIGNAL, COREDUMP_CODE and SUPPORTED_MASK clearing hunks, since those bits and struct sizes don't exist here, keeping only the PIDFD_INFO_COREDUMP check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index a014db891aaa8..cfecc1098170e 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -440,6 +440,10 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 
 copy_out:
+	/* Only report fields that fit into the caller's struct. */
+	if (usize < PIDFD_INFO_SIZE_VER1)
+		kinfo.mask &= ~PIDFD_INFO_COREDUMP;
+
 	/*
 	 * If userspace and the kernel have the same struct size it can just
 	 * be copied. If userspace provides an older struct, only the bits that
-- 
2.53.0



