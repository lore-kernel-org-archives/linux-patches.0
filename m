Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BD1237180;
	Fri, 31 Jul 2026 08:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485942; cv=none; b=iHgpELwR+2e7PLnQ54mmyGQf/fT8mkzI6jvW3IBei8TCyZvU76X+grbB2t/l0QodtFCwGPonU/daa7Lp014D41/DudD8uT0RcWKVidn1rIzv3FPxbzpl/XOt1dzJ9MFNu9tj15ysmY55d5A+odvuibRAY9gPN2A/yXpUWoOtWB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485942; c=relaxed/simple;
	bh=4BUtVi13DuPTG5svH+TF1KEJyx0VjRhzHThtT8IqGWk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UX2OjHwar1Q943xYwKZ1Mn9ENy2zmz+ze3VNzlEedroNMvzfaMKNEQZSV9t8uvpgkkwIDbq4spD+NEtrP7Fy8TMpsXazFlSdfYoBy4RotTweCsPpQmzW6Pw5PgT4Zpr2h1bgvsJNFLdJDXZff8MimqUhfLRDlriD5s4EWttLFDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bOuJOOOL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bOuJOOOL"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V8HaET1325949;
	Fri, 31 Jul 2026 08:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KLjbZD5oAyYVBTYXP/7B6lFRcd+5xh
	bmVAFsdv10rlU=; b=bOuJOOOLwEZov739h95NQLDnBNVeBI2Iz1iuq2jXH6ymYs
	VHlI4BUG8twTw4KN96sAKWQZDBWSDydFadVmakTFkyLjUpjnKIJH6JqPgn+uY+KR
	Ew8A4iKi7YlSmdKYHehKJ7HZWF66Xs6gLJdEKjsHzYlfFJMH3Uznrw75nPfUhMY8
	xfdCGvRerW/0jJbmdDmzxxP0i95bLsKqMGjVWBKQU7mkILh7zSILzwWAp35ivE3x
	GnDZaPPAXdgT8tzJCx45barWgJfeo9bW1lQbNQ3Oq2kNYBuaay2YelWx3caaO3/A
	K5Em2MoDuDCaZeHafnb2mfYgoF5HAYeQoRURkscg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0y43a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 08:18:58 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66V7vO3W005393;
	Fri, 31 Jul 2026 08:18:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhq1b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 08:18:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66V8Itji50135454
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 08:18:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3B162004B;
	Fri, 31 Jul 2026 08:18:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0EC920043;
	Fri, 31 Jul 2026 08:18:54 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 31 Jul 2026 08:18:54 +0000 (GMT)
From: Sven Schnelle <svens@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, stable@kernel.org,
        Heiko Carstens
 <hca@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 7.1 667/744] ptp: ptp_s390: Add missing facility check
In-Reply-To: <2026073120-elm-purging-e006@gregkh>
References: <20260730141444.267951807@linuxfoundation.org>
	<20260730141458.442328931@linuxfoundation.org>
	<669b8e16-19a6-49bf-a1ef-a7bce5075a9a@kernel.org>
	<2026073120-elm-purging-e006@gregkh>
Date: Fri, 31 Jul 2026 10:18:54 +0200
Message-ID: <yt9dzez7inbl.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GO-apovigLyIx_0tmtkRL8V_TwHCPKX5
X-Proofpoint-ORIG-GUID: GO-apovigLyIx_0tmtkRL8V_TwHCPKX5
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA1OSBTYWx0ZWRfX1346ebFhwuXg
 XSqSz7D01U8FvP2Z5Sv4FXQurzytvzI6hWS2FvJiQePGDhOPlfy/fhvRSSN6OWQmG0LEmkUAnBG
 IBXnYq7AEQ4r5qZuT04lUpZOF1G1/Bo=
X-Authority-Analysis: v=2.4 cv=dYuwG3Xe c=1 sm=1 tr=0 ts=6a6c5a72 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=bC-a23v3AAAA:8 a=VnNF1IyMAAAA:8 a=ag1SF4gXAAAA:8
 a=VwQbUJbxAAAA:8 a=uxCiRjAj_QmEOy6f3AoA:9 a=FO4_E8m0qiDe52t0p3_H:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA1OSBTYWx0ZWRfX3qnMOBanvYVa
 UDM9njoTtQrT5tW81FG0vqYI/Wu1wivjZofH4Y8aL8n+4EElagHf+etD1TorWn+tErpXXrbVD1+
 1zFpZkwL/rsB+zXOvongc+gliKNxlhFbRTs3W+h6NkeaXPlilm/rQIPw3A6IZu3rdGr8rvFi/Yi
 4quFilh2pM+8+ksZXlxSHpAxa6AiQxCRQ5T9dEPGtoYujrnzWaE2ve27XsYAYTveeqRbdKkTRKG
 8ECv//YQ9/YrNh7f5wrO9g9NKjEFEBu0x84aiO0qfe7KreTsdb+6ZoBK4bMCNW9+QaWOnPwQrSf
 nD8xUGAofq7+KmeI5v8+aAvQO6d30mCVPCJXo5+owjoWeBLzDEuQ3HCQ2IrN3Ws9Xr17vcj2QCB
 3hZfR742+WyR8f0xF0n8AT6tWNMUEA/eNfdeZ2HApQRgQSlaeb8CmCWJcdv3U+0ufXr5aMEgUio
 lkz3GTE6PLLVdQzWC/Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310059

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Fri, Jul 31, 2026 at 08:21:26AM +0200, Jiri Slaby wrote:
>> On 30. 07. 26, 16:15, Greg Kroah-Hartman wrote:
>> > 7.1-stable review patch.  If anyone has any objections, please let me know.
>> > 
>> > ------------------
>> > 
>> > From: Sven Schnelle <svens@linux.ibm.com>
>> > 
>> > commit e78f1ac37afcb16cb6fef8a2c92591eab6558956 upstream.
>> > 
>> > Only register the physical clock when facility 28 is installed
>> > and PTFF QAF returns that PTFF QPT is available.
>> > 
>> > Fixes: 2d7de7a3010d ("s390/time: Add PtP driver")
>> > Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
>> > Cc: stable@kernel.org
>> > Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
>> > Link: https://patch.msgid.link/20260714130342.1971700-3-svens@linux.ibm.com
>> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > ---
>> >   drivers/ptp/ptp_s390.c |    6 +++++-
>> >   1 file changed, 5 insertions(+), 1 deletion(-)
>> > 
>> > --- a/drivers/ptp/ptp_s390.c
>> > +++ b/drivers/ptp/ptp_s390.c
>> > @@ -107,6 +107,9 @@ static __init int ptp_s390_init(void)
>> >   	if (IS_ERR(ptp_stcke_clock))
>> >   		return PTR_ERR(ptp_stcke_clock);
>> > +	if (!test_facility(28) || !ptff_query(PTFF_QPT))
>> 
>> ptff_query() here needs:
>> 9de445d8296a ("s390/ptff: Export ptff_function_mask[]")
>
> Ah, good catch, now queued up.  How did you find that thing?

Maybe we should change the documentation. I was wondering whether I have
to mark that as a dependency, looked up ./process/stable-kernel-rules.rst
which says:

  Note that for a patch series, you do not have to list as prerequisites the
  patches present in the series itself. For example, if you have the following
  patch series::

    patch1
    patch2

  where patch2 depends on patch1, you do not have to list patch1 as
  prerequisite of patch2 if you have already marked patch1 for stable
  inclusion.

Which lead me to believe that I don't have to add stable@ to the the
other patch, but looks like this was wrong?
