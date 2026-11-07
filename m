Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061681;
	b=LjU8E8wiHowYE5XecHj8X4CkTr5PfavQW13QssyWyV4AG20uWsYEP8/oKWI3vqjGko59
	 0/RKYDFOlGvcutSrJtR3jSby7ape+Pj39jPcjqXX5MYTaxHFhCDOUst2VKiR8DnzWsF9r
	 vZsBgaty5vDYubL/SdglKgyJ97sc5SLfe0qEcenPyaJ+94z3K2JmgkoQF5TVSVQobWswN
	 OjIzn3VkQjtco/HPoHWMT109pLUnXv8iflindnXUO2wBKhy+r5eBShc9a00bFczOKhivw
	 NhKWIGG+7cuNEvwxIt21ncHp13EhdJDi+c8v0csAYhvpQdR/5G9T5cOkG6vyJkhbXNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=atBqLDt2AR0xbu9dqchtFs6DBn4e8l0cs23qbRYH4i4=;
	b=y4PiRTI9NRJwEI/Nd6IYyMEJco1x3EvyaFBy4rWDtjqV2RlInN3sUK8B3vu/Tp+m0Hgt
	 C5fye3C/uQoh+MpsnEGLW4BAHf5Em2WnxyY0jd3HsAC07pqIBe4y7uCftxYlkEt6gQDxo
	 reYFPmZUhNmBQUcpT5IixL2XyADrG26ngk9guVls54uoKsHunHGI451243Chg9QRwQlAP
	 YgDtqB/uShHlclvfBUMNL6upiusgNOOmz7y7igz+jI6hZEcitEGecH+az3IKbWbb98o3O
	 56FJgq363FHYWmyeXeoQit1O7iubVDuFjQKpiRtlqs+82g+4xYnxyoYJ8IpcEIGHfjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ol6IhAwW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69CA606A32F;
	Sat,  7 Nov 2026 14:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ol6IhAwW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6536C1F008A1;
	Sat,  7 Nov 2026 14:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061680;
	bh=atBqLDt2AR0xbu9dqchtFs6DBn4e8l0cs23qbRYH4i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ol6IhAwWIVXzHk9RZfSYfjhbx3oDvAycP5sdI0rG5cgZYf1QMfzijrN4AaouwoNn3
	 u0UoiFQ80mtS3lsdiLHv39hp4QWxHOyiikVujrqtSEX+4IgODmXb8LvkuGZNaX+E04
	 6b/t6LXSEK5hG4NbAVG5ReDChJuIBTV+g4hIu/yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0732/1536] xfs: check for fragments when full-extent sharing matches
Date: Sat,  7 Nov 2026 08:45:48 -0500
Message-ID: <20261107135018.070542358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -174,8 +174,11 @@ xchk_refcountbt_process_rmap_fragments(
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


