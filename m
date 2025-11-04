Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2BB2FB97F;
	Tue,  4 Nov 2025 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762264502; cv=none; b=DGyvY154TwpTDoaM1euafwHGF/+2XnIKltrYlbifXYt2oyTwZ+OWVYakR0ItsSHYlTeK3Z6IvLTLWD8tKZSp0cUllOCLj4ZVkYcyNWqcteOUx5nN9PRLw5uuVSBrFRfceCMWjudxdYhl66Q7xDDv27uxFtIoXWwN1i2J+YIC7ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762264502; c=relaxed/simple;
	bh=O+N3sj/CoWnUzXo8xcYnlkd3hswiu99QHXdJNd/gJvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEXvKbOtfbyMdX3ytW2AW1pQ7AHt6hkQRXPZdZ8+FGWGuIXw6LOdWG9PA6/suw9fTZ4P7NzPC83nA7Ov5IHnXepLuicrXs3lz6UImpW+2ummWGo9lDKG7DRAUwdsnhgG7EwdzyTQ1Mkg6FIXvfkkruEjS9wvC3H5UId1BvI2/b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTMhzVQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTMhzVQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A22C116B1;
	Tue,  4 Nov 2025 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762264501;
	bh=O+N3sj/CoWnUzXo8xcYnlkd3hswiu99QHXdJNd/gJvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XTMhzVQTJj9tp5NvdMB3oTxShB64IJqinB/WXs9xe7Ubc9MmrB5L4NB5dfusE+1sm
	 i1uKInZy5GZL7sSPdGSzmpZrS88/tkO+lKPwV52RP0PWEvVyAjDs5u99I/XI+u6iad
	 Wlz4gE3qLmamIeLj5X36MIUMQp4x1U3B8LsgfqFJZocJOJ4NbviWhq7ymC6sLSdCiB
	 u5DC0D+H4Rg0C4+4S5i/RSCtxzYxr9BLdQ+j8sHZHLLsg/eS8K/pkpGaVnQJHIMUIA
	 mdfAeW48Gh1TG+z8Nl0tthiHAJoH9t6TopJFyAsIfOJWMfWuYS8IK0zkbJ3rrC2ViR
	 9J6++pVkta4dA==
Date: Tue, 4 Nov 2025 08:55:00 -0500
From: Sasha Levin <sashal@kernel.org>
To: Colin Foster <colin.foster@in-advantage.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>, steve.glendinning@shawell.net,
	netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.17-6.1] smsc911x: add second read of EEPROM mac
 when possible corruption seen
Message-ID: <aQoFtH9_z5Q4cD9c@laps>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-103-sashal@kernel.org>
 <aQC8y_aM6wtcbnDh@colin-ia-desktop>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aQC8y_aM6wtcbnDh@colin-ia-desktop>

On Tue, Oct 28, 2025 at 07:53:31AM -0500, Colin Foster wrote:
>Hi Sasha,
>
>On Sat, Oct 25, 2025 at 11:55:34AM -0400, Sasha Levin wrote:
>> From: Colin Foster <colin.foster@in-advantage.com>
>>
>> [ Upstream commit 69777753a8919b0b8313c856e707e1d1fe5ced85 ]
>>
>> When the EEPROM MAC is read by way of ADDRH, it can return all 0s the
>> first time. Subsequent reads succeed.
>>
>> This is fully reproduceable on the Phytec PCM049 SOM.
>>
>> Re-read the ADDRH when this behaviour is observed, in an attempt to
>> correctly apply the EEPROM MAC address.
>>
>> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
>> Link: https://patch.msgid.link/20250903132610.966787-1-colin.foster@in-advantage.com
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>
>> LLM Generated explanations, may be completely bogus:
>>
>> YES
>>
>
>I agree this should be back-ported. Do you need any action from me?

Nope! Thanks for the review.

-- 
Thanks,
Sasha
