Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057853;
	b=bCXVtNNjn25+1COX8GKKcY9asWw431xMt5OfAUWdoIzFElS0T1mV5NI6F8Zwk/jwJ1Ks
	 zrKaNHjFb/z5BT7VyYXpzb2EwFM2+Ez5DR6nsK/1IhRhnWKuz9IluuxXkFIL4opLeXHGs
	 NKL9bTD0Ms9jQU/Ctu5mYAq/MkbWJt56MhDrsxh976o4hGLTX22NN29BcweovuYWmkZTS
	 +er3nQN3HnxlvoVHg0hbdHtjwIHb4IYXRVNaPCnqHElhyd1XuR2jTEiKBuO10ThCHz5bC
	 RuHAlM4mjbczkVkkDiD1kOBjJx9WmmrdeDrgIBtV7sfxQjBif2phgJOV9bH6M74iu9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VUY4rGQW99MuC7PZFB5PM/YbwgZvR5acq9ptSPTwdHo=;
	b=fNAQ6qBzQOiGknF/I2coMjlLZBbJ3ZXLP4dk7S7Ppxx0Ro+KfekKNBJXoLWaAvA+SVQn
	 AHV8gf/9vMx2IazSKTsiN1bbflKhPVynJtJTXo4FNO27VVrvaEeHSlXlK+08/OjK8LHEa
	 YcRSoLSXdAsEow110Z+NzohO3fhWgDIc04mHAy7BnqtUP5A8re8igMKopQfLTJGPlCsVA
	 muE5mzaOUdZneCTmXB0Lz9krpBoenLPRYGk1+W5LWIS8ImTjn34IL8X7u5TzyNT0HG4rO
	 f/ySduz7VsoWbIV9r1U6gcqRaqRBa1pO+LOrE2diWK+TfC9XlQ4isG6IbU/cDo/M3eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B0C7ClTt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474C5606A32C;
	Thu, 19 Nov 2026 03:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B0C7ClTt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBBB1F000CE;
	Thu, 19 Nov 2026 03:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057852;
	bh=VUY4rGQW99MuC7PZFB5PM/YbwgZvR5acq9ptSPTwdHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0C7ClTtt8okft0LfhUJAQNmfUjaR49bJjML96IlREQEMIkIVUheitfqzrXr/0138
	 AiihHcB6k/w2XV7jULIqVacvkijVCF4Shj0/yr3RYe36W1p+lpZa5AolVgZVTUWaJF
	 A3iMUKV1gU0goWrgbhVnoVL6ENjlowX0u2pUTVhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.10 0278/1848] xfs: check for fragments when full-extent sharing matches
Date: Wed, 18 Nov 2026 15:38:36 +0100
Message-ID: <20261118145923.852076550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 95e213c1ddb40dfb0a8178ed35c9f29992a320e1 upstream.

LOLLM noticed that xchk_refcountbt_process_rmap_fragments returns early
if there are enough rmap records that overlap the space referenced by a
refcountbt record to match the refcount in that refcountbt record.
Unfortunately, it never checks the fragment list in this case, so it
won't find the discrepancy between the rmap and refcount btrees.

Cc: stable@vger.kernel.org # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -157,8 +157,11 @@ xchk_refcountbt_process_rmap_fragments(
 	xfs_nlink_t			target_nr;
 
 	target_nr = refchk->refcount - refchk->seen;
-	if (target_nr == 0)
+	if (target_nr == 0) {
+		if (!list_empty(&refchk->fragments))
+			refchk->seen = 0;
 		return;
+	}
 
 	/*
 	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)


