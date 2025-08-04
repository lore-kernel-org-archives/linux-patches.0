Received: from smtpcmd02101.aruba.it (smtpcmd02101.aruba.it [62.149.158.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B19154BF5
	for <patches@lists.linux.dev>; Mon,  4 Aug 2025 06:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754290716; cv=none; b=bUjpg+ZX4FrmQGSBLTb8kXRPHq201WHpqqOXEv/rDnIyp+mdKZ+P1XXf+LZPRPT1Le5upLHs/laW/0VayNwU6RxNriTk3Ab0b7Bthy/GhiZh+zAon9wNBN2iD1J+2FpJkkCrZyx/d/JGHzVSEvbL6ZR6m3pJkWnNt4ajQGa42yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754290716; c=relaxed/simple;
	bh=k3YM9tQ2l2o1U6LBLDVZO2fu1leT0T+RaubNE/2o0vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYZQTeLBIMtyx7k3uejfpU39euPYd/Z4Co/RK4oqkv8ULvQ8FlX1z7guU7eAVQTW7iaNvVtrZBBgUAxcKosQ3Z/pBEXciWNiaTVtjmef2827lXcUxzj7laXTRwQ7T0+wT5eG9aJl/Aa+Yw/3ZYx1DU0IfTvXu3Qg7Op5CJ9Entw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com; spf=pass smtp.mailfrom=enneenne.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=GLaJPQ00; arc=none smtp.client-ip=62.149.158.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="GLaJPQ00"
Received: from [192.168.1.57] ([79.0.204.227])
	by Aruba SMTP with ESMTPSA
	id ip6RumBNeloieip6Ru0GWE; Mon, 04 Aug 2025 08:55:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1754290524; bh=k3YM9tQ2l2o1U6LBLDVZO2fu1leT0T+RaubNE/2o0vs=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=GLaJPQ00hRZe9umbjapte10b4OILapAYyGPIWRm905I6cZW/4F4rxWJulMKYbmEl7
	 lJiEc4jiRK9VHA/nUKCHMCnN2nM5mgvEz0/+rHAX+0j+fBJmTbE1blfIRttFRo4J/S
	 TJxoIKT1CdSZGqxYLzax+2/6Bt8jXfa7+CjTrJAWbye3Q36fbXHPuumwJTGMuA14t7
	 OclPymOwl2yX8owd0utAezr0/RLd7rsk7G4KglVfb7icBjJD18qtEmorU2yQ44ls5T
	 TrhgaYoXka7b0N732zCc8bJMLoF/wvvQIi36ZvRTok0NDKPd17ripdvcGH+OY6zQwl
	 zo4/75iInjmAA==
Message-ID: <f6960b65-6c87-48e6-b7cb-6472f99ccfb4@enneenne.com>
Date: Mon, 4 Aug 2025 08:55:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.16 51/85] pps: clients: gpio: fix interrupt
 handling order in remove path
Content-Language: en-US
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Eliav Farber <farbere@amazon.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, mingo@kernel.org,
 tglx@linutronix.de, calvin@wbinvd.org, bastien.curutchet@bootlin.com
References: <20250804002335.3613254-1-sashal@kernel.org>
 <20250804002335.3613254-51-sashal@kernel.org>
From: Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <20250804002335.3613254-51-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfFduN5NoswrjmZlAJKsmFntt/bfFVR5uxbEl9r2kHDnuDauZn8dxu1CkvEXra7IOzZQIf8mQVgAq+s2A4mQeSOhH38tqgG6UoT5DI70GM6rBNhyOC/2T
 B1Hn/RIKfozwA2h//YxbLwuEF8lAoYIBApbvv1uEHtfq578AB0iKJK5Sq/HpUWR/VQGvlDGT8ajTPftn/6bvyzaj16FTBUNdWLwiyAIHmLyA60urbngoUOt/
 w5Y7d+QbO0nRCB47WCtlcyFdt/J1TVfvFuQWCJmJwY5SXl3reFuhfNiApwKZPhe+nGsDetONFN2N2Qm9z3LR8s1hVauw+XEZ/UKdBjjlsHQBN+ZpuVSyoJkI
 o0ONhW6epLI5Xf9P6HFAgkWWu85863wwNbEjZnpLjQaLPBYDeFrOYX4+G+7vEpLxRuyXrCLTr7yQfRR6X7hHxI9SuHdL+DFtefgpcbTYqS1tphPiMyk=

On 04/08/25 02:23, Sasha Levin wrote:
> From: Eliav Farber <farbere@amazon.com>
> 
> [ Upstream commit 6bca1e955830808dc90e0506b2951b4256b81bbb ]
> 
> The interrupt handler in pps_gpio_probe() is registered after calling
> pps_register_source() using devm_request_irq(). However, in the
> corresponding remove function, pps_unregister_source() is called before
> the IRQ is freed, since devm-managed resources are released after the
> remove function completes.
> 
> This creates a potential race condition where an interrupt may occur
> after the PPS source is unregistered but before the handler is removed,
> possibly leading to a kernel panic.
> 
> To prevent this, switch from devm-managed IRQ registration to manual
> management by using request_irq() and calling free_irq() explicitly in
> the remove path before unregistering the PPS source. This ensures the
> interrupt handler is safely removed before deactivating the PPS source.
> 
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> Link: https://lore.kernel.org/r/20250527053355.37185-1-farbere@amazon.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>

> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Based on my analysis of the commit and the surrounding context, here is
> my assessment:
> 
> **Backport Status: YES**
> 
> This commit should be backported to stable kernel trees for the
> following reasons:
> 
> 1. **Fixes a Real Bug**: The commit addresses a genuine race condition
>     where an interrupt can occur after the PPS source is unregistered but
>     before the IRQ handler is freed. This can lead to a kernel panic - a
>     serious stability issue that affects users.
> 
> 2. **Clear Race Condition Pattern**: The code shows the problematic
>     ordering:
>     - In probe: `pps_register_source()` → `devm_request_irq()`
>     - In remove: `pps_unregister_source()` → (implicit devm cleanup frees
>       IRQ)
> 
>     This creates a window where the hardware can generate an interrupt
> after the PPS source is gone but before the handler is removed, causing
> the handler to access freed memory.
> 
> 3. **Minimal and Contained Fix**: The change is small and focused:
>     - Changes `devm_request_irq()` to `request_irq()`
>     - Adds explicit `free_irq()` call before `pps_unregister_source()`
>     - Only 3 lines of functional code changes
>     - No new features or architectural changes
> 
> 4. **Similar to Other Stable Fixes**: This follows a common pattern seen
>     in other drivers where devm resource ordering causes issues in
>     removal paths. The kernel has many similar fixes for CAN drivers,
>     network drivers, and other subsystems that have been backported to
>     stable.
> 
> 5. **Low Risk of Regression**: The change is straightforward and doesn't
>     modify the driver's functionality - it only fixes the resource
>     cleanup ordering. The manual IRQ management is a well-established
>     pattern.
> 
> 6. **Affects User-Visible Stability**: A kernel panic during device
>     removal/module unload is a serious issue that can affect system
>     stability, especially in environments where PPS devices might be
>     dynamically added/removed or during system shutdown.
> 
> The commit message clearly describes the problem, the root cause, and
> the solution. The fix is conservative and follows established kernel
> patterns for fixing devm ordering issues. This is exactly the type of
> bug fix that stable kernel rules recommend for backporting.
> 
>   drivers/pps/clients/pps-gpio.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
> index 47d9891de368..935da68610c7 100644
> --- a/drivers/pps/clients/pps-gpio.c
> +++ b/drivers/pps/clients/pps-gpio.c
> @@ -210,8 +210,8 @@ static int pps_gpio_probe(struct platform_device *pdev)
>   	}
>   
>   	/* register IRQ interrupt handler */
> -	ret = devm_request_irq(dev, data->irq, pps_gpio_irq_handler,
> -			get_irqf_trigger_flags(data), data->info.name, data);
> +	ret = request_irq(data->irq, pps_gpio_irq_handler,
> +			  get_irqf_trigger_flags(data), data->info.name, data);
>   	if (ret) {
>   		pps_unregister_source(data->pps);
>   		dev_err(dev, "failed to acquire IRQ %d\n", data->irq);
> @@ -228,6 +228,7 @@ static void pps_gpio_remove(struct platform_device *pdev)
>   {
>   	struct pps_gpio_device_data *data = platform_get_drvdata(pdev);
>   
> +	free_irq(data->irq, data);
>   	pps_unregister_source(data->pps);
>   	timer_delete_sync(&data->echo_timer);
>   	/* reset echo pin in any case */


-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming
