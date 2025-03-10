Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B774E22D7A6;
	Mon, 10 Mar 2025 17:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629032; cv=none; b=QmSDvh9T3MN/Iby3WMlbRn7xDvdlo+DHGVTpAg/gpp10bucRfLL/jC6zEpJXHDat77+q+veAXT1oRaS0/CaigPBsuhGbK7r98Q3Yu8h8GKMtoZ44NhdsLEmNZK0B+9kJ7+s+En2mWS0v6YG7G53gi0bKn9P+P0o8VDrqUSAU8DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629032; c=relaxed/simple;
	bh=OykMeQKMcahpsFib61X5qBH4DHstIvGa+jvCuokfPj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6Q++zufk6dYk+5hJO/XAaNXKdvSZGuBY1McxFkLJDzvO2Ii+vKD+3i93fRxmQHP+3PZCd3niUHkSEr+eOKrwYJPr5i2H5PseJAu70yMJ8LpQ3Ht9IU5dqPXYNpfuHnYg4DG1nhGCf2j+S9WovSbsKaPoIYFA7MPtHrILkZ+Dj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDaZVV7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDaZVV7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB41C4CEE5;
	Mon, 10 Mar 2025 17:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629032;
	bh=OykMeQKMcahpsFib61X5qBH4DHstIvGa+jvCuokfPj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDaZVV7pp6AzYf7d+SmDgbCOfwhRlb5gIMCgb99VEFbr9uSc4JugLiarKnaoM2peX
	 VSnLNviLdh9T1CWV9zhKjrjeuk9jZ89X8lTQrGv8OvQ0CgN5VLSgD5hLjej18uYMSf
	 nah8xVlnwlylyXOj3YBcD4yfzp7hZdYOsGiPFvsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/620] NFSv4.2: fix COPY_NOTIFY xdr buf size calculation
Date: Mon, 10 Mar 2025 18:00:00 +0100
Message-ID: <20250310170551.683454917@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 271e5f92ed019..4d8a6f0537148 100644
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



