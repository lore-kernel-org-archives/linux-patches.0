Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CC51FB0
	for <patches@lists.linux.dev>; Tue, 16 May 2023 01:17:16 +0000 (UTC)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230516010937epoutp03aa83ff62ad079748df3b1ecf76b0ce8e~femkTtily1389913899epoutp036
	for <patches@lists.linux.dev>; Tue, 16 May 2023 01:09:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230516010937epoutp03aa83ff62ad079748df3b1ecf76b0ce8e~femkTtily1389913899epoutp036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1684199377;
	bh=O+iOB5oA8PL36Tgptx1DPTVH7ixNY4am+/sSLQJKE3Y=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=LXvDRjr+1M8ixJCCslwouRrnIm/M9zQSmdL36BnIYV4RSYLdG0yo8Ugf47HN5Q3wg
	 dsdaXYHVIBSOFmJbuxDx19C3avI2eIjel690KfRHRwMLQC32bmrwFxvJ6eVGNuX1YA
	 BfZQMDEbtaSgdWDAyuvAvNp+lsAU0hx1iNUbKuTI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTP id
	20230516010937epcas1p3bca2d40439d1d065813cf2e611db1039~femkCWbos0479104791epcas1p3G;
	Tue, 16 May 2023 01:09:37 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.38.241]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4QKynX4dpdz4x9QC; Tue, 16 May
	2023 01:09:36 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
	70.BC.39132.EC7D2646; Tue, 16 May 2023 10:09:34 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20230516010934epcas1p215fb52c0c1302c0eb9b7b863149fa09e~femhpMd9Y1470914709epcas1p2x;
	Tue, 16 May 2023 01:09:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230516010934epsmtrp297dd7733a389953b79f6423afbf95e6f~femhoZPsC1082210822epsmtrp2m;
	Tue, 16 May 2023 01:09:34 +0000 (GMT)
X-AuditID: b6c32a39-e23fa700000098dc-68-6462d7ce1f48
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	EC.A8.28392.EC7D2646; Tue, 16 May 2023 10:09:34 +0900 (KST)
Received: from youngjingil02 (unknown [10.253.98.199]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230516010934epsmtip2fde469a231e5af08a37594a4e2aa9fb7~femhbQkal3002330023epsmtip2j;
	Tue, 16 May 2023 01:09:34 +0000 (GMT)
From: "Yeongjin Gil" <youngjin.gil@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
	<stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, "'Sungjong Seo'" <sj1557.seo@samsung.com>,
	"'Mike Snitzer'" <snitzer@kernel.org>, "'Sasha Levin'" <sashal@kernel.org>
In-Reply-To: <20230515161750.705280788@linuxfoundation.org>
Subject: RE: [PATCH 5.10 307/381] dm verity: fix error handling for
 check_at_most_once on FEC
Date: Tue, 16 May 2023 10:09:34 +0900
Message-ID: <075701d98793$13bf59b0$3b3e0d10$@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQG2PVCkGRo76yUkNrMaiZ51e2bR8AGzewWsAhkyfjSvhEUqMA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJsWRmVeSWpSXmKPExsWy7bCmnu6560kpBg2TLCyaF69ns7h84hKj
	xaY119gstvw7wmpx4pa0xYKNjxgd2Dw2repk89g/dw27x4vNMxk9+rasYvT4vEkugDWqgdEm
	sSg5I7MsVSE1Lzk/JTMv3VYpNMRN10JJISO/uMRWKdrQ0EjP0MBcz8jISM/UKNbKyFRJIS8x
	N9VWqUIXqldJoSi5AKg2t7IYaEBOqh5UXK84NS/FISu/FORqveLE3OLSvHS95PxcJYWyxJxS
	oBFK+gnfGDMW/jrDWrBPoOLkil0sDYwHebsYOTgkBEwkOmeldjFycQgJ7GCUePX5ExOE84lR
	4mv/XRYI5zOjxK9/p1i7GDnBOlac7Yeq2sUo0TZ7OyNIQkjgNaNE13cvEJtNQF/i17FzLCC2
	iECwxJeL+5hBGpgFpjFKrHzTwgKym1PAWuLHNHaQGmGBeIkbSzaA1bMIqEr8eT2NGcTmFbCU
	OLxnCjuELShxcuYTsBpmAXmJ7W/nMEMcpCCx+9NRVohdThI7znxhhKgRkZjd2Qa2V0JgIofE
	g667TBANLhIdd9dDNQtLvDq+hR3ClpL4/G4vG0RDO6PEiodzGCGcGYwSf9/fh/rfXqK5tZkN
	5ANmAU2J9bv0IcKKEjt/z4XazCfx7msPVLmgxOlr3cyQwOaV6GgTggirSVyZ9It1AqPyLCS/
	zULy2ywkP8xCWLaAkWUVo1hqQXFuemqxYYEpcoRvYgSnWS3LHYzT337QO8TIxMF4iFGCg1lJ
	hLd9ZnyKEG9KYmVValF+fFFpTmrxIcZkYGhPZJYSTc4HJvq8knhDMzNLC0sjE0NjM0NDwsIm
	lgYmZkYmFsaWxmZK4rxfnmqnCAmkJ5akZqemFqQWwWxh4uCUamBqesT7Z2HzskU/+/0Mlqso
	3be3VohKrjY4JKsiszw1fnZBMsvFmTbXJ/N83y+h8eL/kSav0CsTFvz3nl74faXx32W7/yjF
	Xpx5j3XFmtMGIS9m7i+tnh71j/dZd/CR9/MipQ+pGs5mWZjnvUNQWnXtj8TVXGsvyDb6Z7kn
	79tr4X7JKXtnkPDf26/Fgv9Hl//IF9Xf8twzyOvEx48rf0kvux4RyV75svx8xZbKDQdYpnhE
	9S91cvoSyrhy4ze3TY7X375hPHvZb/W6aWkhX+P3lhi9Ucl7f9/159Z+nbt1Yea5uy/MubZz
	3catrdv5L3RySHb2zr2x/deXVb8444oY7nl9PM7wTPv69QoP5Zm5vEosxRmJhlrMRcWJANWN
	4RJqBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWy7bCSvO6560kpBld3iFs0L17PZnH5xCVG
	i01rrrFZbPl3hNXixC1piwUbHzE6sHlsWtXJ5rF/7hp2jxebZzJ69G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bCX2dYC/YJVJxcsYulgfEgbxcjJ4eEgInEirP9TF2MXBxCAjsYJWbcfc4G
	kZCR+DPxPZDNAWQLSxw+XAxR85JRYtnmKUwgNWwC+hK/jp1jAbFFBIIlvlzcxwxSxCwwi1Fi
	4d7fzBAduxkl1u2fyAIyiVPAWuLHNHaQBmGBWIlHnX+ZQWwWAVWJP6+ngdm8ApYSh/dMYYew
	BSVOznwCtoBZQFui92ErI4QtL7H97RxmiEMVJHZ/OsoKcYSTxI4zX6BqRCRmd7YxT2AUnoVk
	1Cwko2YhGTULScsCRpZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjBMaSltYNxz6oP
	eocYmTgYDzFKcDArifC2z4xPEeJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZq
	akFqEUyWiYNTqoFJabWA2y+pRdy/9pRKT2QR/BoWGgn01gfzippl8dkGtsu/mnxLP/R5VXLi
	lUMbthYvWHHlTBbjji+aJst2uLz+n9zxwkLidpCUsWjUkZ+bbikdO3a46+ScyRrOSz/1rb3A
	vHDdgS4lTvFFriKq5hsk9UxFf7UpfnR6HGe0dKq+VaGq1RpD7476rPDnKjfMdi85u9ugPdq7
	7dSGDd4/l01zUTX9HHxwh+DTBsG/C2QWP/1e8n8F69wlM6bEN62oLtA8L2/pUv+/07LCsl+i
	Yw/vy6C3fNJH/kkvfSnGbW0Y2Oq2672E6+2OfN2pk7/KRWYX7EqvkorKeHRVnTssZebDa0fZ
	eyMe3r/f/vbwxfVKLMUZiYZazEXFiQBuK6qqEAMAAA==
X-CMS-MailID: 20230516010934epcas1p215fb52c0c1302c0eb9b7b863149fa09e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-ArchiveUser: EV
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230515174837epcas1p3624d7b3e158107dd951fc08a777bd8c2
References: <20230515161736.775969473@linuxfoundation.org>
	<CGME20230515174837epcas1p3624d7b3e158107dd951fc08a777bd8c2@epcas1p3.samsung.com>
	<20230515161750.705280788@linuxfoundation.org>

> From: Yeongjin Gil <youngjin.gil@samsung.com>
> 
> [ Upstream commit e8c5d45f82ce0c238a4817739892fe8897a3dcc3 ]
> 
> In verity_end_io(), if bi_status is not BLK_STS_OK, it can be return
> directly. But if FEC configured, it is desired to correct the data page
> through verity_verify_io. And the return value will be converted to
> blk_status and passed to verity_finish_io().
> 
> BTW, when a bit is set in v->validated_blocks, verity_verify_io() skips
> verification regardless of I/O error for the corresponding bio. In this
> case, the I/O error could not be returned properly, and as a result, there
> is a problem that abnormal data could be read for the corresponding block.
> 
> To fix this problem, when an I/O error occurs, do not skip verification
> even if the bit related is set in v->validated_blocks.
> 
> Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only
> validate hashes once")
> Cc: stable@vger.kernel.org
> Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
> Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
Hello Greg.
This patch is the wrong patch I mentioned :(
Please check the v2 patch I sent yesterday.
If you are still confused, would it be better to change mail subject and
send v3?
>  drivers/md/dm-verity-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index d9c388e6ce76c..0c2048d2b847e 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -482,7 +482,7 @@ static int verity_verify_io(struct dm_verity_io *io)
>  		sector_t cur_block = io->block + b;
>  		struct ahash_request *req = verity_io_hash_req(v, io);
> 
> -		if (v->validated_blocks &&
> +		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
>  		    likely(test_bit(cur_block, v->validated_blocks))) {
>  			verity_bv_skip_block(v, io, &io->iter);
>  			continue;
> --
> 2.39.2
> 
> 


