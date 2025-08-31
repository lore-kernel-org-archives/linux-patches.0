Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94714315C
	for <patches@lists.linux.dev>; Sun, 31 Aug 2025 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756659140; cv=none; b=djlmXu2DnMFqzj83mQYokVPa+T4ZNtnDO4tEldxK+Rv1DAdjiJsszA3NXVLUbDqZDWg3bvWaq/GEH340ILSCWPrBnORG8P5Kdc1PWcI2nNaWb3hWksLut/g8w4gLEdwUUHMOInntKw/Jriesn0ykLaau7RTEYucfQWawBGMBRwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756659140; c=relaxed/simple;
	bh=hVSF5GCY7baUcWAUtuUC9vi9KJDhH75Sh4Qo8VCd340=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4t9G6V0glHpxlG6Eqgbn4dxMRTkCE/BQa+hcR4GKBRbxFZ6ChzyWsw2wc1BOOAoUP+Qhm7QcfS/V1ky0ScXKjcAt671BqBnnfQpKpXCjQjBixKlWqQPxDgnU+MYc5mPqwkGgJI5fGMhi1Pztm8n9ieix3Yzx+xmspVBrwaOJ70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZmhZTO0a; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZmhZTO0a"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b0411b83aafso130987066b.1
        for <patches@lists.linux.dev>; Sun, 31 Aug 2025 09:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756659136; x=1757263936; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xVRAiqDOKLqVp+buslyfxt4z88i9IW6+14Og48x7tGw=;
        b=ZmhZTO0aNDB0bP+yAjT1cIB7ajL8ETRxTLsl7cRKaFhPENb9vO6oVjNvdDtpn3b/ag
         edv5Nkk920REOitpFj/BhK55UVJo/mncmM3/CiJIIrgBZXnm1etC+QLZCzYtO3FtkAOv
         1Sinn34oTyFqVFgHAeU0YF3bAOIHrizE54v5r7Zap/QXbdAfXSzCMWlV8kYLTmuvxkKa
         MatKmzRoYuer+dyUXw7p1hWzNt+FUdT593cBtFTarH8goc8vmmR7uKHYtqLd5T+ckFSA
         YfluNXkj8+jUbYV43JlIGTG3frPQ/Ev5NU9nWFqedlucflXBC7bojGT/Yaitz4o8IGst
         X3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756659136; x=1757263936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVRAiqDOKLqVp+buslyfxt4z88i9IW6+14Og48x7tGw=;
        b=nQrsTwYZiugF3qdPcGkizVreKe/zL69cK5vqtFITGpAggnFwUccD+mko/EdYABT8sJ
         jeVcnyE9zo+qY0/mYYoCWUTPBRjbdL9VqIFC7Z3kqz8M3DhPkRM7FF5haSJML2PaxN5F
         AY9IhSd+dzea6sj+MU6Q9+1MpebY3mxCB794fKRIp0hk/1TY9/J94sJ0YMB6s37qqUHY
         u7EQGUL4Skpn/uYT2uZdujB5a9HScKRsYVue5iidtnJ0yTOMzWA23K0khAo1H1zph6Hl
         xedohK7lhTXUOas8M3DmHUHmmol0fOJnwVZAPWUIQ9keiQXCqBxoEN8zjp52vbhuZZal
         mLUA==
X-Forwarded-Encrypted: i=1; AJvYcCV3qnR7A1+5jW5BcGrxYe9+F7kbcHfkPUfh4revvBVycfUEh7rlaGPayo0gjOrwfcD7X7JFCLGc@lists.linux.dev
X-Gm-Message-State: AOJu0Yyszi+m9JxnvluPkyPl/7zCgaQYrZm3FXlxBzsZHEYS8IC+po5+
	ioV10htUbNLizEwCljVRPC0x/URGM5xRYcFiu9aR0lF1+cS/E6auMTeXOG12jQfj+Zo=
X-Gm-Gg: ASbGnctURiI4jB4JbJ+cET0ta5gfIsoVs50R3A1zO6Gccj+G4YAEc/vvAjouZwhfbnC
	EyooEuMX/0ABiCtX4FmsjdDIX7CYWYhAaN3EZmta8qrWMUM7LAG8u4UmkOsIvsZ6zZ9dJd0wQ7D
	XNlHHAmD7iXXIxqjehkt90raxs6sseDXU2hxomk6BDpX2ehuhc/5nchc7HMqRqS8LGqe8540mPy
	WwEPxd/PrDjHU3hrcFICkbMsKHMBgK6TP0ZRAq5nPyu+A98My7XOmvSJMktMjcAPViry0x7zsXQ
	r1gINdoH5fca7MjrCeWyPYIYbdRv81M42UqQftS7aMTjUZrHZ355Vme+nJcQTX6yssxm4y7UR/M
	9HCphKf3bDDsNPGJxG6fFmwNLUtHO92Z1vdav6zPX
X-Google-Smtp-Source: AGHT+IEvnfJujsi5cFXshPDKJ17p+0VdURuecWHuMZzw11hzdDhPHuf8F3r8bz38kGFw/bXwl8ZBIA==
X-Received: by 2002:a17:906:3757:b0:b04:1249:2b24 with SMTP id a640c23a62f3a-b04124939a7mr274932766b.37.1756659136055;
        Sun, 31 Aug 2025 09:52:16 -0700 (PDT)
Received: from linaro.org ([77.22.248.223])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff16b57124sm475098266b.28.2025.08.31.09.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 09:52:15 -0700 (PDT)
Date: Sun, 31 Aug 2025 18:52:09 +0200
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Rob Clark <rob.clark@oss.qualcomm.com>
Subject: Re: [PATCH 6.16 278/457] soc: qcom: mdt_loader: Fix error return
 values in mdt_header_valid()
Message-ID: <aLR9uVafCI6Xd8aC@linaro.org>
References: <20250826110937.289866482@linuxfoundation.org>
 <20250826110944.250667129@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826110944.250667129@linuxfoundation.org>

Hi Greg,

On Tue, Aug 26, 2025 at 01:09:22PM +0200, Greg Kroah-Hartman wrote:
> 6.16-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dan Carpenter <dan.carpenter@linaro.org>
> 
> commit 9f35ab0e53ccbea57bb9cbad8065e0406d516195 upstream.
> 
> This function is supposed to return true for valid headers and false for
> invalid.  In a couple places it returns -EINVAL instead which means the
> invalid headers are counted as true.  Change it to return false.
> 
> Fixes: 9f9967fed9d0 ("soc: qcom: mdt_loader: Ensure we don't read past the ELF header")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/db57c01c-bdcc-4a0f-95db-b0f2784ea91f@sabinyo.mountain
> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This patch breaks firmware loading on most Qualcomm platforms, see e.g.
the replies from Val and Neil on the original patch [1, 2].

There is a fix pending, which should soon land in mainline:
https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=qcom-drivers-fixes-for-6.17&id=25daf9af0ac1bf12490b723b5efaf8dcc85980bc

For the next 5.4-6.16 stable releases, could you pick up either the fix
or revert this patch together with commit "soc: qcom: mdt_loader: Ensure
we dont read past the ELF header"?

The problematic commit ("soc: qcom: mdt_loader: Fix error return values
in mdt_header_valid()") wasn't backported directly to 5.4-6.1, but a
quick look suggests that Sasha squashed the problematic change in the
manual backports of "soc: qcom: mdt_loader: Ensure we dont read past the
ELF header" (at least for 5.4-5.15). I think we will need the fix for
all trees (5.4-6.16), or we should revert the patch(es) to avoid the
regression.

Thanks,
Stephan

[1]: https://lore.kernel.org/linux-arm-msm/ece307c3-7d65-440f-babd-88cf9705b908@packett.cool/
[2]: https://lore.kernel.org/linux-arm-msm/aec9cd03-6fc2-4dc8-b937-8b7cf7bf4128@linaro.org/
