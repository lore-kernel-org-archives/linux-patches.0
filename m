Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E45151988;
	Wed,  5 Feb 2025 14:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765921; cv=none; b=M7qCe2GzjrlOL7yMCSSSHpz8+VrDVHx6MUzc+h6TuooJfhDuQcauYDlx8qxH2Z2rgtyyhjw+PYqycoZglxX9Q9qK3o6LxW3u9dIP6mYYDeQC9ZisYYAJYlVrmegkDOPK3d01C5C9AKCy4uxw+8rYE4wV0OlLerEU5Y4T5lfOhwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765921; c=relaxed/simple;
	bh=Ci4gyaQj4G3wKopUP+D5VsCV25cTMlawKVvqca2aHGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWEgkmkcGCAtzcdeQ77Un1iptnnFNQ6zTiL/sGxNNWBpNnwQTmu5y8sd0dDWGGIuPCszWSrfY76bEYdCs7iivIDJYNfpP6OV9OSpaLKPTlvZSl0e2O8fIb7tgDA5z8rohpDgKI/IyR6Rr1+lNQfBUTjr9xqIXKaKm1OD1Q941o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRKwaIx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRKwaIx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E602C4CED1;
	Wed,  5 Feb 2025 14:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765921;
	bh=Ci4gyaQj4G3wKopUP+D5VsCV25cTMlawKVvqca2aHGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRKwaIx/tuC4VtexfPPRGCLVFbz5CMQ/TKa0Dn9pAG8cJFWAIwutWNPjjxZyWqwOM
	 KEv8X6n/a8dyYrShk9GaRm1Zc6FnQcYWHPkzLwU+uBubodWv/S7PnnqxLTTNcSHRqt
	 RHn7hMFwSMYeH1S4499Mxi+AcKdV6JymuuJWuaI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 312/393] NFSv4.2: fix COPY_NOTIFY xdr buf size calculation
Date: Wed,  5 Feb 2025 14:43:51 +0100
Message-ID: <20250205134432.249348402@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit e8380c2d06055665b3df6c03964911375d7f9290 ]

We need to include sequence size in the compound.

Fixes: 0491567b51ef ("NFS: add COPY_NOTIFY operation")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs42xdr.c b/fs/nfs/nfs42xdr.c
index 9e3ae53e22058..becc3149aa9e5 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -144,9 +144,11 @@
 					 decode_putfh_maxsz + \
 					 decode_offload_cancel_maxsz)
 #define NFS4_enc_copy_notify_sz		(compound_encode_hdr_maxsz + \
+					 encode_sequence_maxsz + \
 					 encode_putfh_maxsz + \
 					 encode_copy_notify_maxsz)
 #define NFS4_dec_copy_notify_sz		(compound_decode_hdr_maxsz + \
+					 decode_sequence_maxsz + \
 					 decode_putfh_maxsz + \
 					 decode_copy_notify_maxsz)
 #define NFS4_enc_deallocate_sz		(compound_encode_hdr_maxsz + \
-- 
2.39.5



