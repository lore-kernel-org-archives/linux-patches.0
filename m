Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601530;
	b=nU7Xk/VszClpQvAfdE1Hq1Qu7mBme6oO/HPPTf815j1T43hcpbIVPgmb/p19PQnavJN6
	 7r5Uoeq7hX1UQthz+749zfdwPABVOcArYC1IlNqWzHQN23Er/Fb+1nzGVXHgKuNRWvJxb
	 bWveCZlYpvbF/Rprpi0fT+m4amE1OTyo7ROQwTXlMTLEl0nqzsynbTzvlQlNHXAO63vpN
	 Micqky5n9I/W4PxP34Mc0Hv1ydXz8Wn2zGrZyeWvxGEESy7N38QJsCqaeDaj3tjwjYdqr
	 jm9H3twKxRYvj/0h7xm9F/Q9ybMOWpxIpzY+5kWzDHSE+73fgIXPs8R/CQqvgjelfmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601530;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=3Qwd5IeDpUYoKVbi14CXRmp0vCTcpiIpKFvrCb+PUaQ=;
	b=rsAI4eARlj4+f8JVE1tXbeDriSy44i3thIlwBNWAvio9rJWSiT3fdYgTn68yeokboQGq
	 V/8rGFB02aaSM0elsBGNI2SZ1ssGBy6qKWEVYXKXw5+i07/XB6R+aZLz8pb51c5BrICdK
	 NH0TpbRncIc5y8EIekTukUyu4uJGaBwECzDVnuG4EapbM/rIC1uj4JRiM0SLYnwpAlbCu
	 k73D2SsUX7TWpTLez2UztKFewZb48FF2XzKh5BDbz7YmnAMuP+0Se0gB4UwjaAz5jZ2ss
	 fPXBtXTl4I/qouRT3UP+YzSA5ADZqGTe+Gvf55Df2yYOfqyv6QjsNjSThIz9UULLcNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fGBW0L6P;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=evXwQXVA;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4317A606A320
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4317A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fGBW0L6P;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=evXwQXVA
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LGQE1D1117013
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3Qwd5IeDpUYoKVbi14CXRmp0vCTcpiIpKFvrCb+PUaQ=; b=fGBW0L6PCB1n3raX
	d/aUhPmemf5kyrJMb2V994vfSQxb8ZW1AUflWoJbMqxkNdQMkyX60NaRpWzwG2ZR
	dyDNPyramva9fABPmwqppOy5x+y3G2Xjpzu+HJAQ8qTdGMQEDtxA5BLJJps0Gfbc
	0RS6PuOx2PIHdwu3bJdDo33JYwkVD1p+N8Eahl+8OsJIsrCWmXNci7Ks5pmN/stb
	gumg0KOS4MOx3tLDNhDJjMnuFbAjLxfI2H6AicbgZ1SvXdgPAikr3eeNDm/5NzI1
	ReUtxdLTy3hBPhb9/wjImsppuSRvPHiJNWyrz7U7vS8e4LyChMQCIA5S5oPDbcDF
	hGURjw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heh5r457q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 16:52:08 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3510d0baf63so2170766eec.1
        for <patches@lists.linux.dev>; Wed, 21 Oct 2026 09:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792601527; x=1793206327; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3Qwd5IeDpUYoKVbi14CXRmp0vCTcpiIpKFvrCb+PUaQ=;
        b=evXwQXVANU7Hc+fYa5g3h6BvwD6INWM+PYDw0tvblFiWgcyL6KKcgP3OdkCb1xI1YQ
         ubx0ebF1bjm3k8ywlDXzQOcRGSCR3xqT9BIpc6NibTb/uzYhVRPn0bfcaa2fjw2+NBcl
         exuxqpYWpQA94/ucDErRTholv4SJazxr8iFHpxcYw/3rf0CLXJqtdbhN+Jex1NiDnpFJ
         xS2uk0pDEnoZ2meQs0aM6ynR0veh4VsryXyZHRz4ReuL8OIzMSW0Cho13mRamHK8TXbB
         RikWcFODmyeFgNF+0ScIxB3M759Bja8w6uMdQxGPX3mZqouyCw4ot68po+p1LXmygQ6C
         Wjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792601527; x=1793206327;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Qwd5IeDpUYoKVbi14CXRmp0vCTcpiIpKFvrCb+PUaQ=;
        b=a9zWA3gs2Z8a1V4BRWOw+AqBbVCegZtswLkjCSceW1g2nQ27gRM7ogId/I0vsNzYf4
         ZDvMSEphVYt5cR2rz0j3yerNqpXe9fS01D5owHE1WLmXlt9GHigDkqZH/T7vo89ByxyP
         x2GPU7NpCI8qoDFJUXQE91PxovOK3zLaV4x3/S0y+EoLH8LnOO6DLzZA/2GPeQ3ICVBn
         OyuKegsL9WMdknKfSNYjZK2TqsqrxgfSY1lpxcNJtdswfBDwMbuyp4PnaJSr5m3G1GA0
         tWFnspzWjbRbUEiTbqlg6xFnMeDt6X4ef+Oh/2jM0b7PaBeq2xndE2ZVobemcYivly3p
         bflw==
X-Forwarded-Encrypted: i=1; AKwUvBx749OlY0i6ZM8gaOyxQOeTe6uTyCrGcA5JfdIcIJobLEVXXo84RYnesXVk3Q83NONV0gF/Eqz3@lists.linux.dev
X-Gm-Message-State: AFq9FYIQSzXAVNLTB95aqk6HHa0j3hwPzpNAK2Kg1M+nrFlckoofux9U
	BAOIa6i/O8lzhEJcuzb8xu44iUgah2m3Ivl3Jwuj86jAbXDjmN70xfnKhWZ66gnFoq1QXLCOEko
	Nvq/CPvt9zZFo/JXysX3hJeohoFTAz8qv6HtYXdI5JuRTDF3eaYtatH4oV1o6
X-Gm-Gg: AYBFou2udypAitnS+hZ3/ylS15HJX9ZCM0dA3LlMtwPv9Z0BQik8kiB1upTskdwN9wy
	Zd3dj8b0O3Ya0UtLOIBJSwDaOIHPEwzBudO0Gx+EgcGTL7C+hQVE0onWAYs0rQ/VygoJSHiNmAS
	lIJZBbzILMGblvSsDYml6c3/JIMbO9ivTbABDFeenI0Hq1f+bMF33dbfFOTl5l9bOQVpqw6H7ss
	SoO++IBL7kSd0d0bsrLbL4IXbosCA8Vd+I4RdYSrx56AEX4F6P5w2v1GjhmKeavsXuKPUk0lIgg
	z/9eyTEq4p3axtklP0tR1oKWF7JbydI+XD+NlZZBgETmhUBT2KIQad8NfO/4iL4fv5kKbGFboBs
	0h9m0AVNz9qRm8nsGkiExiqjhmtY1Mcy4fp9OdQHyYA==
X-Received: by 2002:a05:7300:fb83:b0:359:8492:2107 with SMTP id 5a478bee46e88-3674c43c286mr5506664eec.10.1792601526918;
        Wed, 21 Oct 2026 09:52:06 -0700 (PDT)
X-Received: by 2002:a05:7300:fb83:b0:359:8492:2107 with SMTP id 5a478bee46e88-3674c43c286mr5506599eec.10.1792601526326;
        Wed, 21 Oct 2026 09:52:06 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3674206d1f1sm8700283eec.28.2026.10.21.09.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:52:06 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:51:55 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        Ard
 Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Catalin
 Marinas <catalin.marinas@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, David
 Sterba <dsterba@suse.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        Randy
 Dunlap <rdunlap@infradead.org>, Simon Glass <sjg@chromium.org>,
        Shuah Khan
 <skhan@linuxfoundation.org>,
        Nick Terrell <terrelln@fb.com>, Will Deacon
 <will@kernel.org>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Conor Dooley
 <conor.dooley@microchip.com>,
        linux-integrity@vger.kernel.org, Palmer
 Dabbelt <palmer@rivosinc.com>,
        patches@lists.linux.dev,
        Piotr
 =?ISO-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>,
        Ross Philipson
 <ross.philipson@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Song
 Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 07/15] efi/libstub: Add generic arch callbacks for
 DRTM
Message-ID: <20261021095155.00003fc2@oss.qualcomm.com>
In-Reply-To: <7-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<7-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=aI5lOr9m c=1 sm=1 tr=0 ts=6ad8edb8 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=PZHjKiIRVRR-A8qzlogA:9 a=CjuIK1q_8ugA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: giiVzl-GFz2GFjoJZuJpzhqHH-FtddAz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NyBTYWx0ZWRfX5MRLmoDHpI8U
 qg+ocex2yYlgd6ZranNC6LxTViF/Z4SbWZZAuvndi62ObEB+tYtdcf9EE9p0N0aHffwEY1BJZ1O
 9mKDR1brDHbW2ddqU8GVGL4uYFXjLFe7IPuEGck13EJItsZj6yoBbcmrGj5A/JAmDVloDCxS0Jx
 pNhBjYoM79XUQ6zBKCc5ZVNMUyxyouOjNTa2z8fBT0jtoMM5+nUDpI64jVpcaYkeTDT5s0tzYkH
 CYimNIp+N2gvwVWOrWflqr666/OGEPO0SALAXyNt2Dg7yvo8DmGjFB8+ZCOdkRF+ofn1E3D44rM
 Q6X7FKalYhgaFpmB25cUfk76uff0aOFRcsEdk8MPTjaF3ZEBodLhrD2LZ+EHLpbP90otBvLDZ64
 SRrUg4HXi2k5EdwgrNnzRgMe/GA0S1oFETyipR3BAPfVXJhuBNipquRBqvhsSGBtcVBnouC1+E1
 Qx6DziN7yiEYXubrIFQ==
X-Proofpoint-GUID: giiVzl-GFz2GFjoJZuJpzhqHH-FtddAz
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NyBTYWx0ZWRfXzaTjJn2U9xo0
 SsUiOikdy3/ESJSEBYW8MnqxgUn46/8UmDkqlWbcMuWwdwU/+onXrwKDexlsgpVbB3taiGSnLW2
 5Lp6CaqEoFd3mHoYsm6UBlIEZmYL5y8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210067

On Fri,  2 Oct 2026 20:31:44 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> If the architecture supports an EFI stub launched version of DRTM, it
> can select the kconfig and provide the hooks under its architecture
> build.
> 
> Have the common code parse a drtm=enforce|auto|off kernel command line
> parameter to set the boot behavior. Support commas in the args list since
> there will be more options here down the road.
> 
> efi_drtm_prepare() is called before doing any decompression or image
> relocation. It should figure out if DRTM is supported, policy-permitted,
> and how much memory efi_drtm_get_extra_size() should return.
> 
> The image handling is revised to allocate extra_size at the end of
> the normal image. The architecture can use this to store any
> information needed for the DRTM flow. It is always contiguous with
> Image, which is a requirement of ARM's specification.
> 
> efi_drtm_prepare_launch() is called while still in EFI boot services after
> Image is fully prepared in its final location.
> 
> efi_drtm_launch() is called after exiting boot services and must
> jump into the kernel through the DRTM flow. If it returns, then the
> normal launch is tried (auto mode).
> 
> The extra_size is allocated directly after the Image. Handle the
> trivial zboot flow now, and vmlinux in the following patch.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Seems fine to me.  Some of the functions affected have annoyingly
complex flows already but this isn't obviously making things worse!

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
