Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C663311955;
	Thu, 26 Feb 2026 13:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772112226; cv=none; b=lDGFyzG/uEfOz/Jo0uFIAdMiatszlHBhaCAUAgS8ocoRce8VbcaE09DGlCmDjsSSPTb4konhWLKNpJeoUePdFusoYAMt5ajlBWT8iJlFGltHEl4uToaH53r1FfiV99euTrEUigYoRNfOgEtgsigVs8sW+hRqZWHdpiRLRlcvePQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772112226; c=relaxed/simple;
	bh=H6NocAc36HaN2QacQtMpABN8rB6BIOrI6xEYKCYUKSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q8stMb2tp/DI2B6/VzCHsq17PFSMU+YtHFK8ZUdltuJqoO/p4wLbld8mMnR4QirSJi2cpxBa+OkABOhoQsD6DS8DInt9aaoVMybkHPMcT4EHxElx04P2jGDbadjt8hEYJW1UGdMo+Xv1TDQ9JdQp01dBIOZ/PQD5OL8otEO0TTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8gDzQV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8gDzQV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB00C116C6;
	Thu, 26 Feb 2026 13:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772112226;
	bh=H6NocAc36HaN2QacQtMpABN8rB6BIOrI6xEYKCYUKSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X8gDzQV/1TFH9yq3tTOSeK0rOO36KjLT/rGoFiqspDBG78V498kELFofrT525s1ou
	 RMXYGPVegdBgLhpELJvhPn5CpF2aVnR/BRWZN7jVrJLh2JyJ7AEXr+BjNlGo06u03S
	 FSHhoJDWuagEpkYbfY9+Yy+ZLHLR1rMSpR1DEbVy2VOMrJlqfVsPgJP4DymbrdCdQe
	 yN4So29Z4HuwuFwLuuiCtLyOKwwpM60fOvw7tTRMKqmmZQjpN+idLWTOcnOjCEqTVn
	 n2hhinoMwiZLSsm68l+PeUxttnPtudEU3dLJpZ3IQDNt2hOUC8YrLzBQ9SKr0Z4CT6
	 zflxhOEFOkOtQ==
Date: Thu, 26 Feb 2026 08:23:44 -0500
From: Sasha Levin <sashal@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.19-5.15] mmc: rtsx_pci: add quirk to disable
 MMC_CAP_AGGRESSIVE_PM for RTS525A
Message-ID: <aaBJYJdDvxo3rbX9@laps>
References: <20260219020422.1539798-1-sashal@kernel.org>
 <20260219020422.1539798-7-sashal@kernel.org>
 <CAPDyKFpnyh0csWRZN5yNZ7+941bGRXF4=yONbQygdDEF3URE6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAPDyKFpnyh0csWRZN5yNZ7+941bGRXF4=yONbQygdDEF3URE6A@mail.gmail.com>

On Thu, Feb 19, 2026 at 11:29:38AM +0100, Ulf Hansson wrote:
>On Thu, 19 Feb 2026 at 03:04, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Matthew Schwartz <matthew.schwartz@linux.dev>
>>
>> [ Upstream commit 5f0bf80cc5e04d31eeb201683e0b477c24bd18e7 ]
>>
>> Using MMC_CAP_AGGRESSIVE_PM on RTS525A card readers causes game
>> performance issues when the card reader comes back from idle into active
>> use. This can be observed in Hades II when loading new sections of the
>> game or menu after the card reader puts itself into idle, and presents
>> as a 1-2 second hang.
>>
>> Add EXTRA_CAPS_NO_AGGRESSIVE_PM quirk to allow cardreader drivers to
>> opt-out of aggressive PM, and set it for RTS525A.
>>
>> Closes: https://lore.kernel.org/linux-mmc/ff9a7c20-f465-4afa-bf29-708d4a52974a@linux.dev/
>> Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
>> Link: https://patch.msgid.link/20260103204226.71752-1-matthew.schwartz@linux.dev
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>NAK.
>
>This patch is reverted in mainline, as it's not the proper fix.

Dropped, thanks.

-- 
Thanks,
Sasha
