Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217057;
	b=QNVWL4ztNh3gtvFJ1YdH5juCkqbLllu1try9VHpn/6HwOgPFvsQILw0y/b3nlbGhX1BW
	 MCVWdAVmQvgcYkmGoF00KP1+sYcPSECjtnTX7ZpDfMj7VFgfw81a/fyRemIeU7wOGs9Sk
	 q/S8N0J1KxrfvSEHd+UZfRO2kIZV+yx5k3LVe+RJ8enqb61FqSPg7DVpYGdhtX/I3KcSf
	 WxlH0kErc6yRL5PMEXo0sHWpv3roDSv+cGHTkEYO/WgcdMuWlZi9PBGUY1Q7GVxONO0HR
	 nA/lGxWyu3ZeLg7RktfsminX91VkYU1bhQMAg6saWnsAJPlji6TiHUeKUfmNHyy/DQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rFXZk3+WcHaMrfHVhkjVYTlFMeTpX9hgiLb1hLVH+JQ=;
	b=iWefb3Pa0Uo3Rh7N9lpRGpQVQQb2yWktMFnN7zm5+DHJElU30QXybzJXBKTC69IWS/ZR
	 nskdc9Y/4ZTcapRpAa4VcFfxS/uCer5EQfQLSbnfCPy4btpThYkqGSVtvyPYkbddLyUiy
	 g4lWljEKdqAkaxG8+5+rYlcWNQFik/1xsll4e8yKv7KQSc6OzuvHitVoMGgxZL/p0L20d
	 q5t6NxIDmzkIaVHrefsE68jx9nOdlIzCpHT6lAK5FbhXnuIBLLlk/EIokG3orVte2YK6k
	 EQnD58DcssrGTwL++5/0PwBOuNtfxBgUJPDaiB+Zh2uNSWzqXcwuLtKsQlqxUN/AzpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQCNmmQB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136A2606A321;
	Wed, 28 Oct 2026 19:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQCNmmQB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C7B1F01825;
	Wed, 28 Oct 2026 19:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217056;
	bh=rFXZk3+WcHaMrfHVhkjVYTlFMeTpX9hgiLb1hLVH+JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQCNmmQB1dRlZTn+eNylPBndunVKwu2oE937IEoxkthG16mfWDMwF7C6C0yqRD64b
	 1QRSB9Xu64Hd+gHqLOwVGubutGx3YDsiLYI8Tr8Np7/Lzw/Tj2aXNZYGQu0TiC4GJI
	 Tbo0ZwAeP1Wrr6j9mu1SO7AzxAnko11ERXWy2kXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 1772/1887] ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
Date: Wed, 28 Oct 2026 18:04:28 +0100
Message-ID: <20261028170539.777113100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5321,6 +5321,7 @@ static int smb2_get_info_filesystem(stru
 		info->FreeSpaceStopFiltering = 0;
 		info->DefaultQuotaThreshold = cpu_to_le64(SMB2_NO_FID);
 		info->DefaultQuotaLimit = cpu_to_le64(SMB2_NO_FID);
+		info->FileSystemControlFlags = 0;
 		info->Padding = 0;
 		rsp->OutputBufferLength = cpu_to_le32(48);
 		break;


