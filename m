Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211926;
	b=XSTkzL6ToIzDnSyYAYbxrH2JAxaWyuYb6PpNP5uEfyoeHZXA16Dh1xAAGVni7VqPeljR
	 X109HRrANUoOt8/1QAbbmiQ8j3ISarpyG5miREnWsPThqNkr1so5wivDZdYse8aQ/FH8a
	 6sIVXfA16iFrj90QUmwsMy7h54yj6NHXTBTDUfqbISUa0JBhp/fec3jJYoQZyqYMWtFE+
	 Zx0YfZa2Q4oefoR1YVaTv6MPExcD32Uu4OPagktnqqdEwYH40jsJaFZHnPCS+iNeTi1U+
	 u3jrN8MAkEyTeIgz8xJqpJs4ymjiCkFhrzZAp+T4wVCue9tuyO5mqPjRTCQP6VFCqUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FuJAp5Gts05xft9QdiiFyLaTCjST4DP+iRs0Til73yQ=;
	b=Opul26QBI3TQFkdd3e8IPuEDyOyMmf69ikgKOZ6UQGTwYCIbB+sg7MD+N2L2QmWO+TmO
	 kTUHhMkuy2KAlis4f46BT/oApc/WugJudp67mk/uA2PbR7PrlNyT4pnlJCGSXmQlaYT26
	 bBoYJYd0WPUBRymDs38vitwZefONps/t+ou2dfUQ5LjblDp5nJWJ3ToXRv+PrQ3eEWetC
	 vk4pH7fX/6VAOWzWZDiJPI9om6mYe7oim0hQq0GMwCsWBhhsoTShQHYVuPKW9Ehu0bPJn
	 4Hfl4+3lkbjXeta+xQXy2hCip3kHOY6FFs0D9q/ZdyM2GrwLw/wdbc0TjhIPHFuHFSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oipoZhEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F95C606A31A;
	Wed, 28 Oct 2026 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oipoZhEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A8A1F01825;
	Wed, 28 Oct 2026 18:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211926;
	bh=FuJAp5Gts05xft9QdiiFyLaTCjST4DP+iRs0Til73yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oipoZhEUKwt8hfshptdu8DexDzE4x+1KZZigyJqbv9AIJU5guPdeKQSrS8enRBNAq
	 91yxqMh/hv1Q2BsDdJeuAXiAw59CK6ZpcoJ7uhpBO1o11IgaDhzRRGNwcTSvchHztn
	 afq1JN7S8Vf6uIlESv2mrnmbTALqyRIEY3rUukm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 548/571] ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
Date: Wed, 28 Oct 2026 18:01:35 +0100
Message-ID: <20261028170021.039930684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Aleksandr Khromov <haa@amicon.ru>

[ Upstream commit c0cd3fc6824122014da2b3b0cb7ddeaa2946ec8e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index de03750a2b0c9..6e3acd0a5687a 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5247,6 +5247,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->FreeSpaceStopFiltering = 0;
 		info->DefaultQuotaThreshold = cpu_to_le64(SMB2_NO_FID);
 		info->DefaultQuotaLimit = cpu_to_le64(SMB2_NO_FID);
+		info->FileSystemControlFlags = 0;
 		info->Padding = 0;
 		rsp->OutputBufferLength = cpu_to_le32(48);
 		break;
-- 
2.53.0



