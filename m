Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A8D25B69D;
	Tue, 11 Mar 2025 15:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706573; cv=none; b=e4wrBoUZH7/XqAoJkMm005FPezj/TuctmX1fzBDcoAX91MMqn6R+IF/W91wRZh7FyRC3KPgS+AEV8gCRJEfam6xgKgW2N4SLE5WqW6/tfSMZzhCN3QoBT7iHIvTwOWBeU+QR7if4uCkxZ7s6FNssZOQNacXmAEolaQ7U4RZI/ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706573; c=relaxed/simple;
	bh=9g/H6p5VbIIXkp48LmMyCXltn0DhTmHmmYOFhRtnYD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSIcnUmqVlSSvOJb8DUsrF1zyoLD6e5tQ2y/krJ9v6j9hVnax71Lvc+T/OzBVwHfPxFos/KzyrSyg7opxwQ+GUnut0Q9l5GHZ9XcUk1yQa/z2N1wTUV6nyfl+Rzg4NTxZFdE5QcIM8Y3SIcAz7BfwBMMnnVAmxXX3zimQj7ar2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVo99XYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVo99XYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DFBC4CEE9;
	Tue, 11 Mar 2025 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706573;
	bh=9g/H6p5VbIIXkp48LmMyCXltn0DhTmHmmYOFhRtnYD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVo99XYR2CvBAEumapaiqWtNRtujowHgsB37kMRvTbvrWklG7ABYOhRIQqJL4XSMH
	 5NGlyRlJm4tXGouaimHoqkpc0wnR5WInncLb01Ddwahc7UnsELZyR4f9JalwL+/GWD
	 iLhlBxKOYLaUeDdOGiFDo8kXd7EhmmaQ2N3nsfck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/462] NFSv4.2: fix COPY_NOTIFY xdr buf size calculation
Date: Tue, 11 Mar 2025 15:56:00 +0100
Message-ID: <20250311145802.067357298@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index df5bee2f505c4..c9987d615ebc5 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -122,9 +122,11 @@
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



