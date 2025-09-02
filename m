Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E9513C8FF;
	Tue,  2 Sep 2025 03:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756784107; cv=none; b=tskhyThJx956VSbm1NCCAfnaDujRpj6TxXwh6bPh4p+OFliEX3ZH+MSKCkX3mvNKPRZQuEktFQ2nyUlXBwRQEJ40YJNQG5nV+5AL+/D1m/tzJ4mG4dVHUbeT/LSj+rM9jL8V69B0xAjn1dwIhbgV8IWZO2vuTdUKbYfgAqvqkcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756784107; c=relaxed/simple;
	bh=9bRgArn8EQPc15szx1UWOiqVCY7DKkYAKC0LuulTftg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVhuZNaYSM1Ma5A++hfO2qOKXTBl2RuHZUqW5FnMUSLMXHoty3WCAkKAg1O/Gr/+X5QJM9Z24u053ujB3Fm5pesHioUfv67XzfEi7JSrzItgG/Qoz6CMJn4GieGyNYp6R/y+qjHZm+jO/aTaU17p8/CiWeTL0+xFR1xvoBeO83s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=l86s5cKa; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="l86s5cKa"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5820vHCc1889082;
	Mon, 1 Sep 2025 20:34:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=X6u3cxx9rLG030RtMo97YtosYPzGzfW8L/jS+og+ozA=; b=
	l86s5cKaby7WOK3XTuPpQuSl+u0BgrVbhrfzhE41P45jdO9K6qIaf2y3n4rF7++l
	ylaMtapVP3XvyfoOY6HVCqFILTsiBdTOF18FNbC37rMpVVG+eFLGQ6dyFZo1hdtO
	DswNwBjMTnyTIRDXtCVi5U44hTXQwE/lieoRKUHJALu22SiJDLtBdEiY5z9tbTBo
	HKXuh30Ee7FHr+IS/kYSMdLkkwSxOha2Mk70BfZ6o5krkMFqnehjYBx6z2qX69/b
	gAkCThR7hbN5I10sY/MzuAB9O/NbyOsaAkaQRjL5T7sr5WopEC6G3UF0KCArPGhy
	Lc1Pm71iuOpQ2LPzURp+wg==
Received: from ala-exchng02.corp.ad.wrs.com ([128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 48uvjyt35g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 01 Sep 2025 20:34:47 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Mon, 1 Sep 2025 20:34:45 -0700
Received: from pek-lpg-core4.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Mon, 1 Sep 2025 20:34:43 -0700
From: <jinfeng.wang.cn@windriver.com>
To: <gregkh@linuxfoundation.org>
CC: <broonie@kernel.org>, <khairul.anuar.romli@altera.com>,
        <matthew.gerlach@altera.com>, <patches@lists.linux.dev>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 136/139] spi: spi-cadence-quadspi: Fix pm runtime unbalance
Date: Tue, 2 Sep 2025 11:34:42 +0800
Message-ID: <20250902033442.145912-1-jinfeng.wang.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250703143946.496631282@linuxfoundation.org>
References: <20250703143946.496631282@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=K8wiHzWI c=1 sm=1 tr=0 ts=68b665d7 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=KwUQ0IL2GcZoDMW8UBQA:9
X-Proofpoint-GUID: oZ0g3Gq-oU_qEIlPJM58FGMNjxJ7pi3h
X-Proofpoint-ORIG-GUID: oZ0g3Gq-oU_qEIlPJM58FGMNjxJ7pi3h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAyMDAzMiBTYWx0ZWRfX5QpQksV3meVj
 lHxNTAcMELnhlNsIS7L8k7mz26uAraF6bY4n2EEflQIplxM5ik+1fcp9zgGbTw0jNPBtR4vba6J
 dqZM0uXJhP9Us5+2H5YfJ32ZzFDgVTg1DAomGXG/4uLL0Q/7G2kyP5qzUt10LrryJLmUUD5YPuF
 QgDur6mKAAIzw271+upweY/61MApTEl00BqK71oveuarbCd6Z/1nJSHdpPB611DPoP7IvST3R/N
 C1J6b7p69i/yyS3pldl8Nz9YCEQ4ka9ykNQb+3lssTCifmGb+afXrLKv3C6qSQS2lOmHE2xwAik
 Xu8IYM6VALxPuce6YAo4V2Brequ7Xvn8EwGx7u1XT5oyBTdfphSbNwUMg8rmRo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 clxscore=1011 phishscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2507300000 definitions=firstrun

1. Issue
  on branch 6.6.y using board Stratix10.

  I encountered cadence-qspi ff8d2000.spi: Unbalanced pm_runtime_enable! error.

  After reverting these two commitsi on branch 6.6.y:
    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/spi/spi-cadence-quadspi.c?h=linux-6.6.y&id=cdfb20e4b34ad99b3fe122aafb4f8ee7b9856e1f
    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/spi/spi-cadence-quadspi.c?h=linux-6.6.y&id=1af6d1696ca40b2d22889b4b8bbea616f94aaa84
  Unbalanced pm_runtime_enable! error does not appear.

2. Analyse of the codes
  These two commits are cherry-picked from master branch, the commit id on master branch is b07f349d1864 and 04a8ff1bc351.
  04a8ff1bc351 fix b07f349d1864. b07f349d1864 fix 86401132d7bb. 86401132d7bb fix 0578a6dbfe75.
  6.6.y only backport b07f349d1864 and 04a8ff1bc351, but does not backport 0578a6dbfe75 and 86401132d7bb. And the backport 
  of b07f349d1864 differs with the original patch. So there is Unbalanced pm_runtime_enable error. 
  If revert the backport for b07f349d1864 and 04a8ff1bc351, there is no error.
  If backport 0578a6dbfe75 and 86401132d7bb, there is hang during booting. I didn't find the cause of the hang.
  Since 0578a6dbfe75 and 86401132d7bb are not backported, b07f349d1864 and 04a8ff1bc351 are not needed. 
  How about reverting the bakcports cdfb20e4b34a and 1af6d1696ca4 for b07f349d1864 and 04a8ff1bc351 on 6.6?

3. More details are belows:
  These two commits are cherry-picked from master branch, the commit id on master branch is b07f349d1864 and 04a8ff1bc351.
  And the second commit(master:04a8ff1bc351) is to fix the first commit(master:b07f349d1864).
  So later focus on analyzing the first commit(master:b07f349d1864).

  the change of master:b07f349d1864 in function cqspi_probe is:
      +++ b/drivers/spi/spi-cadence-quadspi.c
      @@ -1958,10 +1958,10 @@ static int cqspi_probe(struct platform_device *pdev)
       			goto probe_setup_failed;
       	        }
       
      -	ret = devm_pm_runtime_enable(dev);
      -	if (ret) {
      -		if (cqspi->rx_chan)
      -			dma_release_channel(cqspi->rx_chan);
      +	pm_runtime_enable(dev);
      +
      +	if (cqspi->rx_chan) {
      +		dma_release_channel(cqspi->rx_chan);
       		goto probe_setup_failed;
       	    }
  	
  commit(master:b07f349d1864) is to fix logical after these two commits(0578a6dbfe75 and 86401132d7bb: the second 86401132d7bb is to fix the first 0578a6dbfe75):
    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/spi/spi-cadence-quadspi.c?id=0578a6dbfe7514db7134501cf93acc21cf13e479
  
      @@ -1862,21 +1877,29 @@ static int cqspi_probe(struct platform_device *pdev)
       			goto probe_setup_failed;
       	        }
       
      +	ret = devm_pm_runtime_enable(dev);
      +	if (ret)
      +		return ret;
      +
      +	pm_runtime_set_autosuspend_delay(dev, CQSPI_AUTOSUSPEND_TIMEOUT);
      +	pm_runtime_use_autosuspend(dev);
      +	pm_runtime_get_noresume(dev);
  
    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/spi/spi-cadence-quadspi.c?id=86401132d7bbb550d80df0959ad9fa356ebc168d
  
      diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
      index 4828da4587c564..3d7bf62da11cb6 100644
      --- a/drivers/spi/spi-cadence-quadspi.c
      +++ b/drivers/spi/spi-cadence-quadspi.c
      @@ -1878,8 +1878,11 @@ static int cqspi_probe(struct platform_device *pdev)
       	}
       
       	ret = devm_pm_runtime_enable(dev);
      -	if (ret)
      -		return ret;
      +	if (ret) {
      +		if (cqspi->rx_chan)
      +			dma_release_channel(cqspi->rx_chan);
      +		goto probe_setup_failed;
      +	    }
      
        pm_runtime_set_autosuspend_delay(dev, CQSPI_AUTOSUSPEND_TIMEOUT);
       	pm_runtime_use_autosuspend(dev);
  
  So the "Fixes: 4892b374c9b7" section in the commit b07f349d1864 seems not correct. commit b07f349d1864 is to fix 0578a6dbfe75 and 86401132d7bb.
  6.6 doesn't cherry-pick the commits(0578a6dbfe75 and 86401132d7bb). 6.6 only cherry-pick the their fix commits.

  I tried to backport 0578a6dbfe75 to 6.6 after reverting (branch6.6 cdfb20e4b34a and 1af6d1696ca4), it failed to boot the board. So 0578a6dbfe75 has other dependency.


Thanks.

