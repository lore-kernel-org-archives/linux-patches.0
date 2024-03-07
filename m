Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B2C1386AA;
	Thu,  7 Mar 2024 20:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709841956; cv=none; b=McBvgTb4B8lY4VtBnBD4PVh2wDO09cmMlne3eurXekvuc5WiAKY2ieU8qkpXRCYA2ve1lXErK/5iaqNcspC3WzYnoY1rb+dQZHessIlpKNgpxPPd132KZSXpEeR4ohcSKLq5SySxKuggXD8WRHHfmsv31YkTUJHVuyy84nT35kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709841956; c=relaxed/simple;
	bh=775U6tmOCnCvcgxB9T6LHuio+YHV/smm6mzK3Co4Ayw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6d+ZvtpmMXlIgZmYNNzsUaBikZw/A/g3SJEEsgXPhFKMwcfTMcAH6Ed5Kou6ZsHQ0lHbJF0meyDRKUvAHNKICBHKboIMST3p/DOSPqHSuJukZrjrmTu5rVeMbT67stysYpon+HQlTB2e4zYye9mH+1v+xetAAkQ6FDIONs9Mdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R90ECROx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R90ECROx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A2DC433F1;
	Thu,  7 Mar 2024 20:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709841955;
	bh=775U6tmOCnCvcgxB9T6LHuio+YHV/smm6mzK3Co4Ayw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R90ECROxPFz8dffa3qZXxLJrgAyFzMj7DUaIAQwh0MslzNCXrNc00gQYuEL/qs41s
	 ku1uGVTRNdRuuuRJ5I55OfzpQ17DUG2rVBMGSP+E9GP6mChrnOgkBP8smrU6kX4RsM
	 TsIAl4spd9unrpnFbxMSyXNiIY8Z3stJSQYC+mNo=
Date: Thu, 7 Mar 2024 20:05:52 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnav Kansal <rnv@google.com>
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
	dvyukov@google.com, elver@google.com, glider@google.com,
	hpa@zytor.com, mingo@redhat.com, patches@lists.linux.dev,
	quic_charante@quicinc.com, stable@vger.kernel.org,
	syzbot+93a9e8a3dea8d6085e12@syzkaller.appspotmail.com,
	tglx@linutronix.de, ovt@google.com
Subject: Re: [PATCH 6.1 214/219] mm, kmsan: fix infinite recursion due to RCU
 critical section
Message-ID: <2024030739-untidy-progress-3db2@gregkh>
References: <2024030457-aware-trusting-9e48@gregkh>
 <20240307183319.3146300-1-rnv@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307183319.3146300-1-rnv@google.com>

On Thu, Mar 07, 2024 at 06:33:19PM +0000, Arnav Kansal wrote:
> It does not apply cleanly there. It seems to me that the commit (commit
> id: 5ec8e8ea8b77 "mm/sparsemem: fix race in accessing
> memory_section->usage") is not a bug for 5.15 or 5.10 due to the absence
> of relevant KMSAN bits in those branches.

I do not understand this message at all.  What does not apply where?

confused,

greg k-h
