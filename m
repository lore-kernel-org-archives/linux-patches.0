Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207753;
	b=Zsh/syncvO57ufwZc//IyEqvhF7hqjNNIMEct0D/ArgpGP4lo50xgaU+Cd9EghM6URk+
	 GckhQnSYyOy5AGO7ANfQJT09mBJByM6EE8ei2lZNs8d7muhh1CBk6fPZhVTUu/zkYikR9
	 gR672uhtQFb7QMV28unPqfkpXyVwxdkkE2aU6HBJzsRGDzEBkA8xAYAfCI9SsHCfD7CnY
	 px0yZsnf9QCts4d1z/sY9cv1Ni+nCLwApNFqfLSzgk/W4vJcWv4yFVhBlLDgZpeYddpLO
	 gRa1fPhnTdyNTfgzlh03il8XwlK5pnZWsBa2kDuYexBCKpkYV5Np4K/ItkCYQ4IeBSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ZbrGW0TjyTPb4U0V/y2QeQZ4+xPelHf1F4mYSDIqvk=;
	b=3n2PvbHu0WnaW+bQaTnaYtRZ4xlKRlAiZU6rAL+tA6TN8JnvAHvFjDzas47XLXS5+V7v
	 rT563AGpKZByy1dfEKpQftWBlAaO5fljnYEwnOsjTwA69jMmgotJOHG4cIWLffRs9iuQT
	 cJAdhkhhDUpiKiZSXJraS+ALsskypBonfeIpqA28Gl0q/ZolATECViUmTZbbhKpkNTPeY
	 kMgGQ7K/BdmxnilWPeZosdP/+t4PNAD+Z48yIISZojsknla+t173sE6ljuXtxy3K7WUPo
	 KWtIE8o2bh7C95disdQNxAMLbQKm6Ug+53iP4Waqq5K9wsDMtp4P64r6TBZnhIE/vNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=puCYEpjb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292A2606A31C;
	Wed, 28 Oct 2026 17:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=puCYEpjb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DF51F01828;
	Wed, 28 Oct 2026 17:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207752;
	bh=9ZbrGW0TjyTPb4U0V/y2QeQZ4+xPelHf1F4mYSDIqvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=puCYEpjbmyH7f+FQIspMTej2XtEJPUyDPMZMN5B9J2kBmgCbPzHvttSuz4lQoGUW9
	 P2KKBokr6Y9w8F4esfUDMyRTPW8yQONimi6uRtsUlMtuziKzA7MHg0x/ZsAE9U5/KI
	 tpHwL6Pkux0fnWfaZQ1w14WPBw+Dk6GSzNC03baw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 125/247] ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
Date: Wed, 28 Oct 2026 17:58:48 +0100
Message-ID: <20261028165950.363119538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Aleksandr Khromov <haa@amicon.ru>

commit c0cd3fc6824122014da2b3b0cb7ddeaa2946ec8e upstream.

smb2_get_info_filesystem() reports 48 bytes for FS_CONTROL_INFORMATION,
that is the whole of struct smb2_fs_control_info, but never assigns
FileSystemControlFlags.  Those four bytes go to the client as they are
found in the response buffer.

The buffer is zeroed on allocation, so a standalone request leaks
nothing.  A compound request can leak: the offset of the next response
is advanced by the length pinned for the previous one, so a reply that
was written into the buffer and then dropped in favour of the short
error response of smb2_set_err_rsp() stays there, and the next reply is
laid over it with only the header cleared.

ksmbd does not implement quota tracking, so report no control flags.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5752,6 +5752,7 @@ static int smb2_get_info_filesystem(stru
 		info->FreeSpaceStopFiltering = 0;
 		info->DefaultQuotaThreshold = cpu_to_le64(SMB2_NO_FID);
 		info->DefaultQuotaLimit = cpu_to_le64(SMB2_NO_FID);
+		info->FileSystemControlFlags = 0;
 		info->Padding = 0;
 		rsp->OutputBufferLength = cpu_to_le32(48);
 		fixed_len = 48;


