Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72761FF1B5;
	Mon, 11 May 2026 02:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778466552; cv=none; b=o0YIT7rXery5sqs/jYx02fKk5aE+ekV+aoC1UmvhKcLkaJlp3+ciFp5H+3Xea4BgnY9+Z69n2lpuvaZOFGm/e+0O6Mzzxxx4MXGW2at/Rj8lz+ODBpRmySTV2qeLs/33FgSL1mCFaX4KTpy+NVz0cAGJq2tbiwrPvTEOrmzq9IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778466552; c=relaxed/simple;
	bh=ZKd33LdlTD49kjt1ofI1QKPg11b8MRScyJSUFohd+js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j90JLXJvbxSopJQaJiEyfAb/Qpn4xe6hp2WDHiu5+wHqp+uIRu2E6mTgX6WxvhiP8L171GUgt4rPCS6zMxPiSawdDwRE0VphKbmDBgL3U26XcVwMfJ0uk0jUysCqiLnCcL9ll+ivsj6BGfDk8DB9b+rAJYsWUD9UDm7msvqlAYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S6Gqo9Qo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S6Gqo9Qo"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64AHxhJG4053403;
	Mon, 11 May 2026 02:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NHm+nA
	/wyEEZG8iTumDlAArrYk1HVtjoeaaWzX3988M=; b=S6Gqo9QoYSodRP/mK2At+b
	cX3PIgEFKLW97p7s2glnMAKN6Blt9RKLZjgXNlS42/uMAmuXIENFjz+qAKPKH6lk
	j/Zu63j777ouCqfQlPvFKMNFl+UWeT6BMJ6R+WzXJO8ojTVUzMwq+0eqntruUISM
	yoaf6sK/Vfjf9ZLnoXP6U3/183MkbqrYMfOjmeRzGWG8XwidPQR5AYFbpffIAcUV
	IEl0NT59Rxo5ma03wlQT7VOG0giu8A4dFiw/yQ83920Usl3mNowYpsMNHQ3SaaXF
	Op486yz+g7FC3mUJzTsRVf6tbr+J3S2ttUTshe3TuVmuXPn/RN1X0kwZx/FK9Yaw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e1ve6x96u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 02:28:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64B2J1rk025788;
	Mon, 11 May 2026 02:28:50 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e2hfg37bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 02:28:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64B2SnWJ57934152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 02:28:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E662520043;
	Mon, 11 May 2026 02:28:48 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F33A020040;
	Mon, 11 May 2026 02:28:46 +0000 (GMT)
Received: from Linuxdev.bl1-in.ibm.com (unknown [9.123.2.213])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 May 2026 02:28:46 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
Subject: Re: [PATCH] powerpc/vdso: Drop -DCC_USING_PATCHABLE_FUNCTION_ENTRY from 32-bit flags with clang
Date: Mon, 11 May 2026 07:58:46 +0530
Message-ID: <177846637465.1289230.8017211033998445491.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260311-ppc-vdso-drop-cc-using-pfe-define-clang-v1-1-66c790e22650@kernel.org>
References: <20260311-ppc-vdso-drop-cc-using-pfe-define-clang-v1-1-66c790e22650@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDAyMiBTYWx0ZWRfX9pPhd+omVj3g
 uJVrPVdOMrApAX/u6i6wEm/N/n3uKVYN0FyVeHsL9pXdXhDN9rMBbfwWcYUthpYMDo2cwNJ3IIX
 goSqsqRXMpJkOIby+tf26yJ5ai7S4xcGtY0zIV+1VNhmAmUlpADGfXZ3SWcmAaBWbuM59khtPzW
 m4Ct10RG7avMQFbiMlomimevdTw/zuxvi6b/1rCO3JeBz9BEoPp5PBMD4bnjUgoEY8PcPuxpYta
 jCMECFSzFeZIYta1X5GzqQVycjljaBD44UKSWwTD77ji84aDK4mgOFkodt+jQdgv4PJi1vIUnNG
 bKnXyUadQmZRqExCIb4g2CG19tsC9M899wj/mmItRgQXnUPPwdqMJmCD9sZNzXk4gfRGI4RNWRO
 OI+XIc5KejLEfx2sghRPm6rSCqA950FB0P8S76Z3sPqaT/j3X2jDwupc+i3uxKOPwBMqdasDE6u
 qN+EkKt+kwphqS8rT5g==
X-Proofpoint-GUID: 6mN0ZK371_wbz1tPaUw2WxB-0AQ1jent
X-Proofpoint-ORIG-GUID: UE8hlCI65WnjE3_tqmx1otXqULUSG8ej
X-Authority-Analysis: v=2.4 cv=CeQ4Irrl c=1 sm=1 tr=0 ts=6a013ee3 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=vtwD8gBtCyEPof04ByAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_01,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 adultscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605110022

On Wed, 11 Mar 2026 17:39:56 -0700, Nathan Chancellor wrote:
> After commit 73cdf24e81e4 ("powerpc64: make clang cross-build
> friendly"), building 64-bit little endian + CONFIG_COMPAT=y with clang
> results in many warnings along the lines of:
> 
>   $ cat arch/powerpc/configs/compat.config
>   CONFIG_COMPAT=y
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/vdso: Drop -DCC_USING_PATCHABLE_FUNCTION_ENTRY from 32-bit flags with clang
      https://git.kernel.org/powerpc/c/60c71369ee356d11ad845ddeb28ceb70ec6cd70e

cheers
