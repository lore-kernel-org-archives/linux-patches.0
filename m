Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061678;
	b=pfhTbZ59I0BZXmIxaSp65PsMvsoiv7dtDNqnKNxwLyMQRinhp0LHEbJNVGA1a58o6joG
	 50m4M+WQ6SNWUMhKctGCZbSD9JNWXed5RZ/+87D6vEV/3B8kL90NB0QEY/nkK2aR7jSTs
	 qBCXkfwHWVhGAHtHuw7WiuRkNFgTOE9ZqAgCViRLoz55MCSThlu22gYRHuGmeCPc2h0Jn
	 a+zYpaLxT7WvpTq4MoYwrDQ0T/9AempjNR5xl+JFj/ngWhWCYhb4QwgMstWPu56rF/7X5
	 jfVqiK1l8dibNYTu/+GYaGfECC6MMjUp7Ctfv2MdpMSiujgXIpccIgYTAkH4/FISQyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j2ix68Cu7u6X2fi+tjV7Cae3JF3rSblqv6+Zv6yDtnk=;
	b=OUpgSh2SZ4PXay5eI6lKxxTmWiVR3QJFGqxtbiGXqY6Rq1Qdr59piw3beysyoag1GrHZ
	 2Kh4Sy6f7Q+zcxuj6SmfMtphFukz8rynAri/lHBAYAq+qCjRswsbLqwZIZA2UUW0v0OZO
	 wz2ApyWmh+OuLupCkL3j6EhcdX8/du7vC0hDD5FSXMb7+S+81uxeoQe79Uu7JUtLG2VTF
	 JMgr/w4negvhhDpeSMpSxJNEHJoRveUz3ZxAJVc7mA7yckbxzQcWS+gPJztoI1Czt8Pwk
	 k0zYO0glJMDPCuzBJ4eSKXsWsrx240j7L5eB1zzGexOqSZwB6HLdjIDqCvgFQ45Uf1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6688b7X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00963606A330;
	Sat,  7 Nov 2026 14:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6688b7X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A339F1F0089F;
	Sat,  7 Nov 2026 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061677;
	bh=j2ix68Cu7u6X2fi+tjV7Cae3JF3rSblqv6+Zv6yDtnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6688b7Xdo+0SR0nyCfBiXrfIhHAAqUW9tx2ZRxw70vOoXtMny+VNlK+5+luaKHiT
	 LIksNBMXMTNJckJon6R5CuexVt3RJjEvPkJxBH1Rr3Ol+sPsV4RYknZ34Tef6XAePT
	 WKr7D8eYnruP7RXhAorKc4XkooTtSNLpnxlNXUMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0704/1536] xfs: fix lost errno returned from xfarray_foliosort
Date: Sat,  7 Nov 2026 08:45:20 -0500
Message-ID: <20261107135017.265967225@linuxfoundation.org>
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

commit 8c4f172c246717b1420f138a159ed15c315a58bd upstream.

LOLLM noticed that we stop the sort early but don't actually pass along
the error code, which could enable repair code to continue running with
an unsorted array.  Fix that.

Cc: stable@vger.kernel.org # v6.9
Fixes: ee13fc67205b98 ("xfs: convert xfarray_pagesort to deal with large folios")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/xfarray.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -943,8 +943,10 @@ xfarray_sort(
 		 * problems, we're done.
 		 */
 		ret = xfarray_foliosort(si, lo, hi);
-		if (ret < 0)
+		if (ret < 0) {
+			error = ret;
 			goto out_free;
+		}
 		if (ret == 1) {
 			si->stack_depth--;
 			continue;


