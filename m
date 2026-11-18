Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050870;
	b=wAWDUozlXcIJ/h40W/mZzztIpaNUpvHh9kQgtIlRzpb0jKghkuUnh4QeFu3BirxC3kla
	 Yq+khKAF4i1/TjbIMIm8KO1Z9wfVUjO41D4g0l5S5UhrivJE0ek7JkaLRmSymDXcanXuc
	 uO+rPnDpJkyJzH1Ubb+IEJFsyOTnqLzzniHhS/pn1a01r/AHMTrYIv+yX0pFGWqgZoiS/
	 r81g39Vi53B1q9csrQasPvKfTMJKzkmsEcoLBdJLQ6Rir8grmo2fR1d+iXcZS3Ppg3HYv
	 xXHlcAtnBuuSB1ATfP82esM8QdfkceqXH71j/IACISjiRqUjHr0FMBAnmeZ9pqMV1Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Q8sL6hP6g24Aq81/9FGZVm4xR2t78KJf49NHInB/Sk=;
	b=s/apDct9y9KXTXmNr9xeAMOkMa+8gpMTFsmUyl6lIU7fMxVkcIY0hMScRKIKGNLn9rz3
	 EgaQFmFqHIgrWdRQGP2dzFcf+82GpRjjrsEpGvKg20X6+BAajlB2GytqCAEFszZ7ECJmp
	 qbtXTzFR8ub3M0j7j6ESbmgYA7+DifG4BDKjs7rjzuqz22FHgzc/zuyEjT1pzLWokOzyP
	 u4O1zjlUKRQYYIVForOmLkIfS2HMY/qVQOHStGcfHixldEPSxdb1RNsx4pSqrZBHpM0vl
	 5KWlm541gaLctDD5XTykp7PVgodNOeHgzFGv0YgoNQF6wHSYFZjyeXG3Lr/8WhVrNUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kocPrwU5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05D2606A31C;
	Thu, 19 Nov 2026 01:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kocPrwU5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DA51F000C4;
	Thu, 19 Nov 2026 01:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050870;
	bh=2Q8sL6hP6g24Aq81/9FGZVm4xR2t78KJf49NHInB/Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kocPrwU5ozkuSCid3j3h/AB6p9sqxx+eHa4GB5IlbqYYdDnikvVxt192ZHBWqB3X5
	 z01b3XfvPweJbBtva9QUtTG2yXBIjK39ASeLo9v7V1xwm4hf1ioo+0nIX81K09QFBv
	 MGLRbfkfZ19iuLlyepsDnYi2sI03xnTR619I3geo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <simon.horman@corigine.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 2847/2857] Bluetooth: msft: Fix error code in msft_cancel_address_filter_sync()
Date: Wed, 18 Nov 2026 16:04:41 +0100
Message-ID: <20261118150344.090167520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 528b2acf434bf4a0fb2969e5222fbe790b95f422 upstream.

Return negative -EIO instead of positive EIO.

Fixes: 926df8962f3f ("Bluetooth: msft: Extended monitor tracking by address filter")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/msft.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -754,7 +754,7 @@ static int msft_cancel_address_filter_sy
 	if (IS_ERR_OR_NULL(skb)) {
 		bt_dev_err(hdev, "MSFT: Failed to cancel address (%pMR) filter",
 			   &address_filter->bdaddr);
-		err = EIO;
+		err = -EIO;
 		goto done;
 	}
 	kfree_skb(skb);


