Received: from smtpcmd02101.aruba.it (smtpcmd02101.aruba.it [62.149.158.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D8A235C1E
	for <patches@lists.linux.dev>; Mon,  4 Aug 2025 06:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754290748; cv=none; b=fq0cDCWN5mqD94UykMkNRTWhLPzT8G/ut8+Ii2zH+bMJ9C/CLT87Bb50Tsy13Thd3IQRXl0s1ABbhTOuZPsNprom02dB/4AX/4Pp4l/DL4zWBk2gKUXejP9BPB93mrLfJmBxHh+c46uLf4rUOz4WCHphrjZWqUB4uEh7kpuT+/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754290748; c=relaxed/simple;
	bh=LSgysigogsq8Vu6IcegPLAJWwCo8lYdgNcydMlXMnL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ENnnEz+BeTCT9y1n4XBrzYoZcUmwRWXIwhJHgXgEz2LfQcywDkqOZygSqulff5+ydq26oj+rd5vLpWuyzL84WNu8jK5ZaHR91N9wvSK+Wvl1YRUbBfxqTEWvZlYmVhfsaNGXuGUakOXCN3TbCCXPU336IfGJOjHDcK5QMLfud80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com; spf=pass smtp.mailfrom=enneenne.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=VYy8Z2n8; arc=none smtp.client-ip=62.149.158.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="VYy8Z2n8"
Received: from [192.168.1.57] ([79.0.204.227])
	by Aruba SMTP with ESMTPSA
	id ip78umBpeloieip78u0GqW; Mon, 04 Aug 2025 08:56:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1754290566; bh=LSgysigogsq8Vu6IcegPLAJWwCo8lYdgNcydMlXMnL8=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=VYy8Z2n8jbbL7C6mzzLMa6VQwA2YtGgoeZJlwAUT0yz9Fn7Say2nLt//YESLQWRqS
	 WiMRYAN+c0KmcxN3h4u0LN9xTP4z7gck8tIsZd12uXVaqe68HYDpbf3p8UXV2fxstH
	 omxDLt+DkxHHc7vMkuq4H2bRb2S/NBXNRtWlng/pBniYnH1kjwxPfgfMXLXGJI4syd
	 DNrlQCutHBe+nRx5pt2RPudgjWgC/69WWczBPkWuDcNMeOExlME4kriw8LZHTDpdG0
	 1GwFyxHy0DmTDf7OXMsOAauRHeWmErTmnpzzONr3f71K+GF7D1PTFu7DEW2Ky23sVn
	 qM0FrymblBvsg==
Message-ID: <42f15255-9182-4c33-b41e-be7c9682d4e3@enneenne.com>
Date: Mon, 4 Aug 2025 08:56:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.1 31/51] pps: clients: gpio: fix interrupt
 handling order in remove path
Content-Language: en-US
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Eliav Farber <farbere@amazon.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, tglx@linutronix.de,
 mingo@kernel.org, bastien.curutchet@bootlin.com, calvin@wbinvd.org
References: <20250804003643.3625204-1-sashal@kernel.org>
 <20250804003643.3625204-31-sashal@kernel.org>
From: Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <20250804003643.3625204-31-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfIiPnIGAED+sXC8HXBL3BWpNdGa56CCnOTvHkYHLVxhMZnXUBtPylEjWy4N7Y6TNtOaW9D01tpACnR7pH4mOLtyE8MlbDmKzBZkwAipFLIrwoSBuTjDl
 sIPrTAp2+gEyZnYWKg0/WHGjTf7rW+Uh2syxrOxMuUQ/qhivKslZvzrv8u/Nw6+B43tKXQbL4suQTyYymm7qetps6K5Q2J3losJjD9Acnw6+xFliiuRAn9n0
 hvLtGd5c39rlFC5Ae38BMKtj8EGN0owIwKktnd7n55bvGSDaPbzrU7gnhDMcnoLSasmVCucAgZ14hp2ceOjfvEZumDe6dDE9yD2lXI+RulwiVJWX+IRFQA+I
 YfEsyMUn1/Hw7h6HxoxKkREXBh2UqO3YoYJbMu9+BDoztwMpLK3ZFQtpZssISVj8Ef+/gTWQstoaDiz+EqiFKp5geHSp/FvXXz1hFiBJCi3wHA02HOQ=

On 04/08/25 02:36, Sasha Levin wrote:
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
> index bf3b6f1aa984..41e1fdbcda16 100644
> --- a/drivers/pps/clients/pps-gpio.c
> +++ b/drivers/pps/clients/pps-gpio.c
> @@ -206,8 +206,8 @@ static int pps_gpio_probe(struct platform_device *pdev)
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
> @@ -224,6 +224,7 @@ static int pps_gpio_remove(struct platform_device *pdev)
>   {
>   	struct pps_gpio_device_data *data = platform_get_drvdata(pdev);
>   
> +	free_irq(data->irq, data);
>   	pps_unregister_source(data->pps);
>   	del_timer_sync(&data->echo_timer);
>   	/* reset echo pin in any case */


-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming
