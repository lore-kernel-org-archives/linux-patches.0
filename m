Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B76F28387;
	Sun,  1 Sep 2024 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208134; cv=none; b=L12ZWk2YcUX6fCd4m1dfj29HcON8rltYF4SbFJ4IIXuFwYRE5r9F/F9FP6sDutY7XyHhEJ4MQgpYWfumHEZphBbIsBMrcl08qVVJuK5G15cadoxXI2oLduo2KTLW285t/wk4VnS1Z3hZ79G66cuvHMnmbHTEALM2vRawvmre9Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208134; c=relaxed/simple;
	bh=VhTGjZ0FxIvqqJ1rjHc4IShOjqVCtq4nKRNeSvOKJVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4WkgXJUB042pjhfSRM9PEaoDwjQmWGsQTp4nN2VNcdTApidjnuu5ihLWPIrhzLweckzVQcNjqWUCYlJdjBArTH2Wv7IxmXhdoEFQ1pmPoHOlbwO6IZu24e7Mvn/sCu3XwTP9wWDCYK2w2cDiRvWVRfpxRr496i6mhKObtZ+FMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZal4fbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZal4fbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866D7C4CEC3;
	Sun,  1 Sep 2024 16:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208134;
	bh=VhTGjZ0FxIvqqJ1rjHc4IShOjqVCtq4nKRNeSvOKJVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZal4fbnaPdwWnZ0E68OL3FrD7FCy3jxvtyn9c7oiyPPLONgAGa/BfC6zr/KQOZy+
	 SE8/3kOFEcw1MB1gx61r2N+Z7hCvGUAB4CcvD0BsZRfmYwd74c6717BgOogzZ5x1Jm
	 vTxIngHgza977n3mmI1L/+FFx9nZbnxkyY5UEkZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 83/93] usb: cdnsp: fix incorrect index in cdnsp_get_hw_deq function
Date: Sun,  1 Sep 2024 18:17:10 +0200
Message-ID: <20240901160810.859988695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pawel Laszczak <pawell@cadence.com>

commit 0497a356d3c498221eb0c1edc1e8985816092f12 upstream.

Patch fixes the incorrect "stream_id" table index instead of
"ep_index" used in cdnsp_get_hw_deq function.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: stable@vger.kernel.org
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB95381F2182688811D5C711CEDD8D2@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -402,7 +402,7 @@ static u64 cdnsp_get_hw_deq(struct cdnsp
 	struct cdnsp_stream_ctx *st_ctx;
 	struct cdnsp_ep *pep;
 
-	pep = &pdev->eps[stream_id];
+	pep = &pdev->eps[ep_index];
 
 	if (pep->ep_state & EP_HAS_STREAMS) {
 		st_ctx = &pep->stream_info.stream_ctx_array[stream_id];


