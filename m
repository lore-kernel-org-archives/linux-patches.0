Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DFF3FB33
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eNAxGSC0"
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39II5dQr019974;
	Wed, 18 Oct 2023 18:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=znEhWGKEBLl+Pkhyojrv4Y0PXmxOtbdPBIDSypafgWw=;
 b=eNAxGSC0Fg6UAii8AAj5taQOPnh2ctQFfX18oPNTXPhJ0wefr3lsBD1C1RiBKvCNFs2J
 Zz1LZvjYZGjKNbZKG2KGaTckG7gtSE+6M0u3yAxy/26Uy4dPLMtr5d2LRNQ/9Hte+w0U
 Cdvxt4ld/Q2kDN3WC2MBm0jxdUkZ5TDL0vzEJj8kajfs0IaqEfh54ZvLunu1nJMopSjW
 gh+B3/CPxXtVAcXVO7gqxxVtQkqvpqhsDAHApJae1zsrV5iKLavrthp/9nm+jxn1c2ey
 KmYHxFWeM9T/TvJlfeRPZoqMvo6KuUM/DtgaD8YUMjdRuYsPFhkEURQAd+39HYJ1ILnP BA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ttmb183pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Oct 2023 18:07:44 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39II7h8P000729;
	Wed, 18 Oct 2023 18:07:43 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ttmb183p6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Oct 2023 18:07:43 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39IGE5IN019900;
	Wed, 18 Oct 2023 18:07:43 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tr811t8qb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Oct 2023 18:07:42 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39II7g2719137268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Oct 2023 18:07:42 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D5DA5805B;
	Wed, 18 Oct 2023 18:07:42 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E3CC58058;
	Wed, 18 Oct 2023 18:07:41 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.watson.ibm.com (unknown [9.31.99.90])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Oct 2023 18:07:41 +0000 (GMT)
Message-ID: <e03ccb1e354cee0eea828cb6f2e6f91714218c49.camel@linux.ibm.com>
Subject: Re: [PATCH 6.4 041/737] ovl: Always reevaluate the file signature
 for IMA
From: Mimi Zohar <zohar@linux.ibm.com>
To: Raul Rangel <rrangel@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, Eric Snowberg <eric.snowberg@oracle.com>,
        Linus
 Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, Tim Bain <tbain@google.com>,
        Shuhei Takahashi <nya@chromium.org>
Date: Wed, 18 Oct 2023 14:07:40 -0400
In-Reply-To: <CAHQZ30BPUtNbQhxvUGMQWP3Ka4UxtaS_NUeK12jtdaheMq4EWw@mail.gmail.com>
References: <20230911134650.286315610@linuxfoundation.org>
	 <20230911134651.582204417@linuxfoundation.org>
	 <ZS6xYa_kjRGvdCG6@google.com>
	 <bd5d2f882e47b904802023d5d4d54d8d4755440e.camel@linux.ibm.com>
	 <CAHQZ30A8R+EDGbrngMOQrXabR=DTHL3Y-1Tv+3RF98VHQ5b68Q@mail.gmail.com>
	 <c9b7de507e26cb4e5111cdc76998f1dcd3c0957a.camel@linux.ibm.com>
	 <CAHQZ30BPUtNbQhxvUGMQWP3Ka4UxtaS_NUeK12jtdaheMq4EWw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-22.el8) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UL_Y2bHQEUmEB297hQwHdMFO7qBoh9hI
X-Proofpoint-GUID: HZzxLl52JR-dvgT1YRVttYnlmaykZ2JS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_16,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310180148

On Wed, 2023-10-18 at 10:35 -0600, Raul Rangel wrote:

> > > > Instead of reverting the patch, perhaps allow users to take this risk
> > > > by defining a Kconfig, since they're aware of their policy rules.
> > > >
> > >
> > > That sounds good. Or would it make sense to add an option to the
> > > policy file? i.e., `verifiable fsmagic=0x794c7630
> >
> > Perhaps instead of introducing a new "action" (measure/dont_measure,
> > appraise/dont_appraise, audit), it should be more granular at the
> > policy rule level.
> > Something like ignore_cache/dont_ignore_cache, depending on the
> > default.
> >
> > Eric, does that make sense?
> 
> I guess if one of the lower layers was a tmpfs that no longer holds.

I don't understand what's special about tmpfs.  The only reason the
builtin "ima_tcb" policy includes a "dont_measure" tmpfs rule is
because the initramfs doesn't support xattrs.

> Can overlayfs determine if the lower file is covered by a policy
> before setting the SB_I_IMA_UNVERIFIABLE_SIGNATURE flag? This way the
> policy writer doesn't need to get involved with the specifics of how
> the overlayfs layers are constructed.

A read-only filesystem (squashfs) as the lower filesystem obviously
does not need to be re-evaluated.

With the "audit" and perhaps "measure" rule examples, the policy can at
least be finer grained.

> In the original commit message it was mentioned that there was a more
> fine grained approach. If that's in the pipeline, maybe it makes sense
> to just wait for that instead of adding a new keyword? We just revered
> this patch internally to avoid the performance penalty, but we don't
> want to carry this patch indefinitely.

I'm not aware of anyone else looking into it.

Mimi

