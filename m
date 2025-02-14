Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D57127E18;
	Fri, 14 Feb 2025 05:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739512481; cv=none; b=bIJ260L3+vQMli/caGpgOUW6sRAHRgaNfr3qk+eWePEPiDdmPM9x8cXYwcsOH+/xv+Fk6UUs5n414avX4xN84V26Uxuo6nF+h2Ti6qquJtfcz3/AFs+XSA+e+aFiWnlXxNTt0+D6IA5FlqcKasPKLLtosYIKYAd58wpyLjnx6r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739512481; c=relaxed/simple;
	bh=Q9yJSVReDDAppABu0RBikijyt2F5uHBFJV41jvoKm18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l3mPgaRoIGZd8GBHiK0s8c198H5ct514WygnVUT8NST1WFHbmq+bbnTzmMcWO1Tdss5xP05EgZc5VWEC9x3PouDDPrkHD8zpOiSOUVTpM75y9Fq0Web7X8BK6ZK3Wses6mEdmwAdliT/gQEi1a2coSNP6AF8aYlxd9hYZ68an+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=raq2HhZ9; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="raq2HhZ9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:Date:
	Message-ID:Content-ID:Content-Description;
	bh=sqimaXT9kayDFL7e+TOq2/bArAC6vZXSj2rt1Po417I=; b=raq2HhZ9X5CTlNRYvn32SXoW9m
	mzClHtXTtzCrLOFzfw7a9G4yS1OkVuxw+s1QxfgoqzefUBnNd7bmuK8Tkd7A57uoT1g3SNRmsLMYS
	v7C2tv0DcJWgAFidnVfDyX602/2neOq9Vc8cS56rI/BmWtqyKGCLOk2w3+VQdcTJ+QsC1rm8D8/a/
	/7ZnhH/5LFj5I5ZRtLmUwqD08MJ0schQifsHpxBiSzILMXYMeQ3IrfPnCLqipyh/cBbgFc/mjHSAI
	qF6TejU/SBKiSPQ3mpB/I7fEPgAUAQZZt0oj53pQCcvxt+v8iTPBCABueKG1eVxS+mqwGFMr75HR3
	RHnI9kkQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	(Exim 4.94.2)
	(envelope-from <daniel@debian.org>)
	id 1tioel-009GIU-UG; Fri, 14 Feb 2025 05:54:32 +0000
Message-ID: <93c10d38-718c-459d-84a5-4d87680b4da7@debian.org>
Date: Fri, 14 Feb 2025 06:54:30 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: daniel@debian.org
Subject: Re: [PATCH 6.12 345/422] ata: libata-core: Add ATA_QUIRK_NOLPM for
 Samsung SSD 870 QVO drives
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Niklas Cassel <cassel@kernel.org>
References: <20250213142436.408121546@linuxfoundation.org>
 <20250213142449.867734843@linuxfoundation.org>
Content-Language: en-US
From: Daniel Baumann <daniel@debian.org>
In-Reply-To: <20250213142449.867734843@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Debian-User: daniel

Hi Greg,

On 2/13/25 15:28, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.

there was a report from a user that this is breaking it for them with
newer firmware versions on the SSD - I'm narrowing it down to a list of
older firmware versions that are affected and providing a follow-up patch.

It takes a bit more time than expected due to the cumbersome flashing
routine (windows :/). It would be safe to not merge the original commit
in the meantime to stable.

Regards,
Daniel
