Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA5024BC14
	for <patches@lists.linux.dev>; Mon, 12 May 2025 21:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747084599; cv=none; b=Immj/mOurhfQUh3a2SI56WXNVXnqe361IlpRINY1DGXDzcfs5iCNlL954UNsCb9C6WLF5zO0Qza3nFnhZ/kArq3gdiWDF76tHSobFiNxqcbbhhGQ8/QFYNDGJoMzF0CYQtoPSPt0nMaPEeaeU49bGXKKYKuXLxVPAYsVkKrxtEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747084599; c=relaxed/simple;
	bh=REsOT5/Kf4epauIk/+gj5qaRQFY+1LyOd7d456HgZ10=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DJt98E//Cf8tlkwc28U8+QUn47pomWZpWk00NlesXzmGiyBJ0LhFG2vOP9VevoU9G0fGdg8RDJcNDijLOFREjAnPy5INVRcK79TTJZuzRTVghT8bIPDPeGM45aGZLbYuodSUVHCoOI+3GsnxHL+0e6QF0PPJws3SPV7xRrLQO9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ATCR0n9B; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATCR0n9B"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-54fc9e3564cso4586615e87.2
        for <patches@lists.linux.dev>; Mon, 12 May 2025 14:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747084593; x=1747689393; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eWbcMuS3JaNmPcNaeeeXONbeofrLDqA7Uwckra+1Fjk=;
        b=ATCR0n9BCWpOWY7sSbzDco01Li+1fnN5shOB+p33i1o5FI1nPULqmNTnfOqRun0yjp
         DgEdZlcTvGx4Wd2rEsCb10zHnxyst+GR20n2X4ozm0gOPygrPZUR/BBUQq1YxVmsuPtL
         3LG1uMAt5yG0vErMCcw+5MdTqVsOnryljbRmE43IMRd9La1Xq2ZEeKJhVO9xvYABBcr5
         fiBUISMytZkz3tQTN+iiSgss4pwYEcD8WIodnjMElpNpwf+VZ76ooWTwGXke8l4ALFLW
         iVqWAwHIcZhF9ndRRVCDc7+UKF9tsDGrTg9piZz1mE4a9nwHc1t0lTRknesl43vqKeb7
         g+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747084593; x=1747689393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eWbcMuS3JaNmPcNaeeeXONbeofrLDqA7Uwckra+1Fjk=;
        b=S4bvZXFslBxC+gHOKqd6vCelZR9AJNFSHE35GeavxCdOyIpTv0gILX4sp2R+hOtQs2
         DH1JYGub/Fsxfjf0EKV+imnbR3XGuAthOJigho9O55rZxy3XcFCgP+9I+g8kncHP2rgk
         hejhHmzZkpbM1X6G46fjSTCy9n9v6N1fUpF42XNEUIw12qAgyLbV8A0ngmpf3El+tDDy
         SdIMNPmInA6qWbapnUlegTGZ03+DQNjNGmStmGtnREcBM9w/VHCXI0JLKj4x4sWhPJIL
         5t/aqkf24A01Fz2QjVMVvXa4wbRZHP3JvcZzqkRcXS69OxJ4ovMu1AWO95+ETuJ6RN8p
         LMqA==
X-Gm-Message-State: AOJu0Yzpq9XpJtXSmwOfdIF59RH2pO1jBp7qdAggpGl03+Bp2vXaUpM8
	hGQje9Lhstz1Zw4IpPr5745oThgsoVvzZB6KAfzs7YPsIVe/kXDO
X-Gm-Gg: ASbGncu6Fl5V8UM9zeNkpg47lBtEsuCtwUyx4pVfDiIcHPPNjEcfRzAdCuxB03oqZga
	I9EdLBuLBH0t1RJwa80hDQaE004/QRMLBsslBwPNRyYx8ANNSEKtCwKGM63gHczSTcZFTQ7ALgg
	0xXLeGDVgw+Ih3b03oAyrAvA7m1YXooyC/4NU6b7zWbvvf0GTJgM28AUgy4E1+NlpVkFTo+Bcsa
	ZRcDg2N041z9KsTTW6tOIbBcXxpkCjMMCv3CEVicBCx3YI9D+zDdvfAWkJleYWrMzTtinh6QyaS
	ub48zAAzEqM+l4dMprAcm6/kgSLKdrVFhbFf18MLu4mHdtpDxInZveyTyKv+80Wmyu2F
X-Google-Smtp-Source: AGHT+IFTxOz++Epfa9FUTfKl46pds1Z1TZVgLGjtOWGgDj44Awn8Wu6umfFxWxnIFLPiy+CDrfxGQw==
X-Received: by 2002:a05:6512:2312:b0:54f:c65f:b908 with SMTP id 2adb3069b0e04-54fc67e2368mr5082998e87.49.1747084593039;
        Mon, 12 May 2025 14:16:33 -0700 (PDT)
Received: from foxbook (adqk186.neoplus.adsl.tpnet.pl. [79.185.144.186])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64b6fe9sm1608430e87.149.2025.05.12.14.16.31
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 12 May 2025 14:16:32 -0700 (PDT)
Date: Mon, 12 May 2025 23:16:28 +0200
From: =?UTF-8?B?TWljaGHFgg==?= Pecio <michal.pecio@gmail.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, Jonathan Bell
 <jonathan@raspberrypi.org>, Oliver Neukum <oneukum@suse.com>, Mathias Nyman
 <mathias.nyman@linux.intel.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, mathias.nyman@intel.com,
 linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.14 08/15] usb: xhci: Don't trust the EP
 Context cycle bit when moving HW dequeue
Message-ID: <20250512231628.7f91f435@foxbook>
In-Reply-To: <20250512180352.437356-8-sashal@kernel.org>
References: <20250512180352.437356-1-sashal@kernel.org>
	<20250512180352.437356-8-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 May 2025 14:03:43 -0400, Sasha Levin wrote:
> From: Michal Pecio <michal.pecio@gmail.com>
> 
> [ Upstream commit 6328bdc988d23201c700e1e7e04eb05a1149ac1e ]
> 
> VIA VL805 doesn't bother updating the EP Context cycle bit when the
> endpoint halts. This is seen by patching xhci_move_dequeue_past_td()
> to print the cycle bits of the EP Context and the TRB at hw_dequeue
> and then disconnecting a flash drive while reading it. Actual cycle
> state is random as expected, but the EP Context bit is always 1.
> 
> This means that the cycle state produced by this function is wrong
> half the time, and then the endpoint stops working.
> 
> Work around it by looking at the cycle bit of TD's end_trb instead
> of believing the Endpoint or Stream Context. Specifically:
> 
> - rename cycle_found to hw_dequeue_found to avoid confusion
> - initialize new_cycle from td->end_trb instead of hw_dequeue
> - switch new_cycle toggling to happen after end_trb is found
> 
> Now a workload which regularly stalls the device works normally for
> a few hours and clearly demonstrates the HW bug - the EP Context bit
> is not updated in a new cycle until Set TR Dequeue overwrites it:
> 
> [  +0,000298] sd 10:0:0:0: [sdc] Attached SCSI disk
> [  +0,011758] cycle bits: TRB 1 EP Ctx 1
> [  +5,947138] cycle bits: TRB 1 EP Ctx 1
> [  +0,065731] cycle bits: TRB 0 EP Ctx 1
> [  +0,064022] cycle bits: TRB 0 EP Ctx 0
> [  +0,063297] cycle bits: TRB 0 EP Ctx 0
> [  +0,069823] cycle bits: TRB 0 EP Ctx 0
> [  +0,063390] cycle bits: TRB 1 EP Ctx 0
> [  +0,063064] cycle bits: TRB 1 EP Ctx 1
> [  +0,062293] cycle bits: TRB 1 EP Ctx 1
> [  +0,066087] cycle bits: TRB 0 EP Ctx 1
> [  +0,063636] cycle bits: TRB 0 EP Ctx 0
> [  +0,066360] cycle bits: TRB 0 EP Ctx 0
> 
> Also tested on the buggy ASM1042 which moves EP Context dequeue to
> the next TRB after errors, one problem case addressed by the rework
> that implemented this loop. In this case hw_dequeue can be enqueue,
> so simply picking the cycle bit of TRB at hw_dequeue wouldn't work.
> 
> Commit 5255660b208a ("xhci: add quirk for host controllers that
> don't update endpoint DCS") tried to solve the stale cycle problem,
> but it was more complex and got reverted due to a reported issue.
> 
> Cc: Jonathan Bell <jonathan@raspberrypi.org>
> Cc: Oliver Neukum <oneukum@suse.com>
> Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Link: https://lore.kernel.org/r/20250505125630.561699-2-mathias.nyman@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi,

This wasn't tagged for stable because the function may potentially
still be affected by some unforeseen HW bugs, and previous attempt
at fixing the issue ran into trouble and nobody truly knows why.

The problem is very old and not critically severe, so I think this
can wait till 6.15. People don't like minor release regressions.

Regards,
Michal
