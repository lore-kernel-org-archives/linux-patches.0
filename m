Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033389;
	b=EaOHIHifQxz77vRgOHO/KZ8bF66kLcXb8qkxKOMEOkYR98hOPqaxeYBupchFPj8KqFZo
	 Y+F2qJwUUkynNhS/MK9evKZnVaMu4FPpr71A2fZb5Zh96Cczn6QwVjzapQjG9Djg3720W
	 ApGJEwx0c/XIQ4dZ8Vp3zF+BbN1tDuZONeeX2KuID2bDWLqwxT78KbBLFcEOikiOLn1iL
	 2SgMZ7w28dDtzqRXDySFjA2nHtPr31CDpASJT5FNPuLfng/tqIrwlJ4hnU4FrmrfJG+86
	 JqLLjjLLaaLqv+ctNLFWDT4d+myPeDiZfsfWfQBR6h9FYytkL9xM9MAY8vKF51SWaJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NwNa8oQdvILxpxQwNLCYYt8Qe7nBIydNKbghUwj/CGw=;
	b=CX/UAbq71pGnOGshXRWSleKy2NpRLjeWSCaVOu951kM5cQ9SYpKVumuQlWNCE9mX/gxW
	 gEdNKGK5xHpIfi9yhGtRQ9+B/R65kF1ilgdA7oWyQ9ukAWsGBfz/qB+UAC424zZLCBOu2
	 L+NtNCEOWfAZXQ93mBNXqBJbhD+vy0jRC2jjkXDOHsaB9fP7LnRtHkQ7lDrOjeuStkW6J
	 uv4M5GoM/JtazODIwKm0if9t+f/JSXUPYWqYLPSyKjNBiO4yugBdmGCsIiHIIRPTH7j9W
	 FvS03IHnV60/IZLXDeapO0bMrbZjbgUbW5TxnXqp0iohcDUtHlY6S62CANVgV/SJvzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4hdN226;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6797360A2605;
	Wed, 18 Nov 2026 20:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4hdN226
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAF61F000C7;
	Wed, 18 Nov 2026 20:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033389;
	bh=NwNa8oQdvILxpxQwNLCYYt8Qe7nBIydNKbghUwj/CGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4hdN226xtNMdVPB4IdkfI61ENu9MsBZaKDR8PlKBLI/TcoKQAbbWicE6EOQizwk0
	 VbL6jpd5R792QJ555Tdx0nkfaYu730OYPSw+FiA3Ml7vgvq6pjetBxYe9qzDZgEGwf
	 3oY2dfNj2+/DIwmNklEOsbntadBzQpxBbh6DXyWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 1752/1756] fs/ntfs3: reject FS_IOC_SETFSLABEL on readonly mounts
Date: Wed, 18 Nov 2026 16:04:39 +0100
Message-ID: <20261118150119.279913701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

commit 5d3e03b70d05162ca49830efcd8b1cd2746a86a3 upstream.

FS_IOC_SETFSLABEL does not check for readonly mounts and
can report success without persisting the label change.

Return -EROFS on readonly mounts.

Fixes: 21dc07ac9c25 ("ntfs3: add FS_IOC_SETFSLABEL ioctl")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/file.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -65,6 +65,9 @@ static int ntfs_ioctl_set_volume_label(s
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (sb_rdonly(sbi->sb))
+		return -EROFS;
+
 	if (copy_from_user(user, buf, FSLABEL_MAX))
 		return -EFAULT;
 


