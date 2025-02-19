Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7891DFDBC;
	Wed, 19 Feb 2025 09:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956531; cv=none; b=B5b4xaAOKdR499Ck7vVV3gQVXKhp93NJf75Cw14flY8MPfAxsjqFGXAqbRcUSFkZLpBXlLoA92OMBFrUF8glotybwBggrWPXswqMkfWJA6Y78PoQo3WPobhBuQtyZ4ShNRxpfEUbH6Rc6HEEU64bM3sE0ts0nlW02WJcmDgBFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956531; c=relaxed/simple;
	bh=UociUvxjI35TKYfi+Y1aQH3OA2ZTOnGePG4UFCS+9P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FC3PIXCHnObr7OBlX+cJ9g7Iwl8arraAtaujvQPmebiMYPSS3JZKncDl1fBJ0YajXRtxFUg0XRSrUIv1v34wAda5dN4CPQDWPG/PFOuKD+2w0/BLO5QXgkhA2GFCbyFo6dryw0FTzctvMaNb8+y8nddFzXSciUld59INMtsyA8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDjsnRCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDjsnRCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBB1C4CEE6;
	Wed, 19 Feb 2025 09:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956531;
	bh=UociUvxjI35TKYfi+Y1aQH3OA2ZTOnGePG4UFCS+9P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDjsnRClurQNmsOksF3fXe6X7D7poS2ERpSbpd9AiG0KV21JDQ7uxhzyvoKj7sAOW
	 Co9iu3glkI0EHGTru9NDSkj5PBVPx6IAT9A/y5TgETuOqOZssoRZ7taBsLinf8ycOY
	 2YlZj3keYMlhPK/aVU+tjGlnz/SI3ShTCGvt3k2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/578] NFSv4.2: fix COPY_NOTIFY xdr buf size calculation
Date: Wed, 19 Feb 2025 09:23:33 +0100
Message-ID: <20250219082701.282168335@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 20aa5e746497d..fd51fd1cf5ff7 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -129,9 +129,11 @@
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



