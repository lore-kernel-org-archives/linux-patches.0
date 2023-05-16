Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2DB1FB0
	for <patches@lists.linux.dev>; Tue, 16 May 2023 01:38:34 +0000 (UTC)
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230516013832epoutp037871971b17cbc785bac00f27b6a7cc64~fe-z1vdcw1006910069epoutp03m
	for <patches@lists.linux.dev>; Tue, 16 May 2023 01:38:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230516013832epoutp037871971b17cbc785bac00f27b6a7cc64~fe-z1vdcw1006910069epoutp03m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1684201112;
	bh=r/3/ao7PaSLqFhtk8CMOq/ZiI92AgMC/qrNVuqN1iaw=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=A2tWepvU9GDT6R1IiD96rl3r4i1lY1dcHGwUcTdkrEMUd2vF79rhA864kWiEEWCy0
	 NKzejjghXIoQXpCrysd0brrtMgpYbNixwW92ztm2DGuZplVlteBVviieATFmKThsvA
	 3GJz5PT4zACCvShUAQJySanJjZLUSxiez13ERv44=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTP id
	20230516013831epcas1p33552c94f97b08af92d0b11ffbf59ca49~fe-zMMLeG1124211242epcas1p3n;
	Tue, 16 May 2023 01:38:31 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.36.224]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4QKzQt6rm5z4x9Q0; Tue, 16 May
	2023 01:38:30 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	CC.B2.13472.69ED2646; Tue, 16 May 2023 10:38:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20230516013830epcas1p41954bab03545ff4be86af3e9a5e28bcf~fe-yiVw4A2472224722epcas1p4z;
	Tue, 16 May 2023 01:38:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230516013830epsmtrp16d1fc84824fd383e90d4015a507a50ca~fe-yhn7Jk1528315283epsmtrp1d;
	Tue, 16 May 2023 01:38:30 +0000 (GMT)
X-AuditID: b6c32a38-9ebfa700000034a0-70-6462de962568
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	80.90.27706.69ED2646; Tue, 16 May 2023 10:38:30 +0900 (KST)
Received: from youngjingil02 (unknown [10.253.98.199]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230516013830epsmtip17202b2b04440f94ad23335712224aeb1~fe-yVHE0b2390623906epsmtip1J;
	Tue, 16 May 2023 01:38:30 +0000 (GMT)
From: "Yeongjin Gil" <youngjin.gil@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
	<stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, "'Sungjong Seo'" <sj1557.seo@samsung.com>,
	"'Mike Snitzer'" <snitzer@kernel.org>, "'Sasha Levin'" <sashal@kernel.org>,
	"'Yeongjin Gil'" <youngjin.gil@samsung.com>
In-Reply-To: 
Subject: RE: [PATCH 5.10 307/381] dm verity: fix error handling for
 check_at_most_once on FEC
Date: Tue, 16 May 2023 10:38:30 +0900
Message-ID: <078a01d98797$1e931f30$5bb95d90$@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQG2PVCkGRo76yUkNrMaiZ51e2bR8AGzewWsAhkyfjSvhEUqMIAACNIQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJsWRmVeSWpSXmKPExsWy7bCmge60e0kpBhNXmFk0L17PZnH5xCVG
	i01rrrFZbPl3hNXixC1piwUbHzFazNj/lN2B3WPTqk42j/1z17B7vNg8k9Gjb8sqRo/Pm+QC
	WKMaGG0Si5IzMstSFVLzkvNTMvPSbZVCQ9x0LZQUMvKLS2yVog0NjfQMDcz1jIyM9EyNYq2M
	TJUU8hJzU22VKnShepUUipILgGpzK4uBBuSk6kHF9YpT81IcsvJLQU7XK07MLS7NS9dLzs9V
	UihLzCkFGqGkn/CNMePE9ilsBbuFK6Yc6GZrYLzL38XIySEhYCKxZtZbli5GLg4hgR2MEnev
	/2MCSQgJfGKU+L7WFCLxjVHi0JsuFpiOhuVr2SASexklTvd1MEM4rxkllsydyQxSxSagL/Hr
	2DmwDhGBYIkvF/eBFTELHGWUaJszgbGLkYODU4BXYsI/a5AaYYF4iRtLNrCAhFkEVCWuz7QH
	CfMKWEp8nTyfEcIWlDg58wnYSGYBeYntb+cwQxykILH701FWiFVuEpOWn2aHqBGRmN3ZBrZW
	QmAmh8TnddvZIBpcJHYefwf1jbDEq+Nb2CFsKYmX/W3sEA3tjBIrHs5hhHBmMEr8fX+fFaLK
	XqK5tZkN5FJmAU2J9bv0IcKKEjt/z2WE2Mwn8e5rD1S5oMTpa93MIOUSQP92tAlBhNUkrkz6
	xTqBUXkWkt9mIfltFpIfZiEsW8DIsopRLLWgODc9tdiwwAQ5wjcxghOulsUOxrlvP+gdYmTi
	YDzEKMHBrCTC2z4zPkWINyWxsiq1KD++qDQntfgQYzIwsCcyS4km5wNTfl5JvKGZmaWFpZGJ
	obGZoSFhYRNLAxMzIxMLY0tjMyVx3i9PtVOEBNITS1KzU1MLUotgtjBxcEo1MDVXqcWqc2xW
	cIj+170uYp2gnvSF7K1zIgy6JKUlN1WvnRzsoVP9+dzF4mmSBV5LAi3tF3LMP5T496h7lWb0
	VO/7XfxlFxf9V5Q8JfNhr2ili1/n7YU1187JW0b9tZxWdfM90xTdOW49f84pKT44l9Y9mdvk
	8lEesRurCi3MBXbp6vTO9Z2UeTNBkMtNuoC3kz83SeveVdt1nKLvtAtMatj8T0+Jt+nJeP3w
	9yvvgDxDsToH+RIzd1Et6T3nZSzUE6dJuUi9WhzHpiYxKad1SUZDw56Fjk9ZV07bGJ5rPWuD
	2if59Kf3LRQuFvJu+qahnf5oYYtNMfvqijMJExz9uP3zg3QXfOeuj+ZTVFBiKc5INNRiLipO
	BACu+dRZbwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LZdlhJTnfavaQUg+Uv5S2aF69ns7h84hKj
	xaY119gstvw7wmpx4pa0xYKNjxgtZux/yu7A7rFpVSebx/65a9g9XmyeyejRt2UVo8fnTXIB
	rFFcNimpOZllqUX6dglcGSe2T2Er2C1cMeVAN1sD413+LkZODgkBE4mG5WvZuhi5OIQEdjNK
	HJ78nAUiISPxZ+J7oAQHkC0scfhwMUTNS0aJ9S0z2UBq2AT0JX4dOwdWLyIQLPHl4j5mkCJm
	gZOMEi1/tzJBdOxhlDjU+pgFZBKnAK/EhH/WIA3CArESjzr/MoOEWQRUJa7PtAcJ8wpYSnyd
	PJ8RwhaUODnzCdh8ZgFtid6HrYwQtrzE9rdzmCHuVJDY/ekoK8QNbhKTlp9mh6gRkZjd2cY8
	gVF4FpJRs5CMmoVk1CwkLQsYWVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgTHkpbm
	Dsbtqz7oHWJk4mA8xCjBwawkwts+Mz5FiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLp
	iSWp2ampBalFMFkmDk6pBiaL9rc6qv/mvC/4xq14sHTt9LLL+39EuNo6fuw0f+N5OXCi6c7P
	bGo7jrqvPTZ9Vr7moZqLDXePTVXSsrjEzddQu7m8O3hT2qE1qR9DD29k+GfSWXPwTOf5TYef
	616dGySZdvP4bP3p87ts+mvelG7ZlP3KOUXqhOD9KLOuO19PhXzymSuhcuRbhFu/a/CF4qOT
	l2Ysm1Yn73NJMP34I60fC2Ulzaa8nnTru+vPvbwVdQVFmmtmJzA618hPPtztzn2H1UjpXCsr
	qxEDl8eD/2vbpKYt6p3dk9Rn+PPGs5ZPU8+0MVXLb/qpEnN25frsqC7zwjNzny2U/3Hq6aEu
	AZW6Fwvdb1Uy3mG3O50wM7BWiaU4I9FQi7moOBEAqvSlBBQDAAA=
X-CMS-MailID: 20230516013830epcas1p41954bab03545ff4be86af3e9a5e28bcf
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

> > From: Yeongjin Gil <youngjin.gil@samsung.com>
> >
> > [ Upstream commit e8c5d45f82ce0c238a4817739892fe8897a3dcc3 ]
> >
> > In verity_end_io(), if bi_status is not BLK_STS_OK, it can be return
> > directly. But if FEC configured, it is desired to correct the data
> > page through verity_verify_io. And the return value will be converted
> > to blk_status and passed to verity_finish_io().
> >
> > BTW, when a bit is set in v->validated_blocks, verity_verify_io()
> > skips verification regardless of I/O error for the corresponding bio.
> > In this case, the I/O error could not be returned properly, and as a
> > result, there is a problem that abnormal data could be read for the
> corresponding block.
> >
> > To fix this problem, when an I/O error occurs, do not skip
> > verification even if the bit related is set in v->validated_blocks.
> >
> > Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to
> > only validate hashes once")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
> > Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
> > Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> Hello Greg.
> This patch is the wrong patch I mentioned :( Please check the v2 patch I
> sent yesterday.
> If you are still confused, would it be better to change mail subject and
> send v3?
I checked that the previous patch was queued in stable kernel.
(dm verity: skip redundant verity_handle_err() on I/O errors)
I didn't know how to handle dependent commit in stable kernel.
There is no problem with the below current patch.
Thank you and I'm sorry for confusion.
> >  drivers/md/dm-verity-target.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/dm-verity-target.c
> > b/drivers/md/dm-verity-target.c index d9c388e6ce76c..0c2048d2b847e
> > 100644
> > --- a/drivers/md/dm-verity-target.c
> > +++ b/drivers/md/dm-verity-target.c
> > @@ -482,7 +482,7 @@ static int verity_verify_io(struct dm_verity_io *io)
> >  		sector_t cur_block = io->block + b;
> >  		struct ahash_request *req = verity_io_hash_req(v, io);
> >
> > -		if (v->validated_blocks &&
> > +		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
> >  		    likely(test_bit(cur_block, v->validated_blocks))) {
> >  			verity_bv_skip_block(v, io, &io->iter);
> >  			continue;
> > --
> > 2.39.2
> >
> >


