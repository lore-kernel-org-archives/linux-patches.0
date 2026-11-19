Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795064635;
	b=nfeQ2pJTazqYsN86jzuy2jTTAfC+3WKMVIhRo7YPs88ljM+TOvfLlozKseZjGL05ctpR
	 e80/GJtICZOPVkGVun7q6YjaHOBXvIrrvCLKbNmBCTTflCtM42j9DuH6/5PWddBWppTK6
	 du9mdQTe2jvs9ldyfNP1fpphLpaWeUxPHiffsQ3nB8Kzv2UDHAgrvlFilEP46zahKTwvb
	 n4uqfrzbPhU+gasCToI38wRCQtjvw0acrfFmrxyU98k4S6nw2qH3/F82xS23FFotqXO2T
	 ckAkBE/lRnXBrF0iq5olsGp4oIdaMeQ9akPLq34b/GrJkbRlKuAhaVRk3zyB1Bshvog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795064635;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=GBL+w+gKm4BciOel47s2fVIuHWYFXENW2ii/MuaXrB8=;
	b=hIJ9rkGAFHukIgGkuOTVMnYCHp79LGW+PHTgiFwGii1RpX20T7zqT2a2VkrbeyEVj2p8
	 hYEjbhODYfqGG4UPhb9WFZqLvk/UzgOQhp6kxY4Qqfcy/BUV6TBB2aRTztmXXeodVUH49
	 HUdXM2Swkwbz0pJcHAdxyc95adUq9XIBL86tnK9c3O40w7+6hdyWa8K12AJjiRA45ClQx
	 EFQZ87u83FOAUjerpefcNxY5G/8BMvJHIz1Kgl4WRFKse4qWCQfKek4p5IdKsdCpi4IPD
	 0ynuFyGyt1IYiHwPhZkdhGtd8TTGvrZlgcdoXqXj2sOGqBn7Lhd5w1ZpxwBdNd3y1sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NZRsnGfw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00581606A320;
	Thu, 19 Nov 2026 05:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NZRsnGfw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9041F000C4;
	Thu, 19 Nov 2026 05:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795064634;
	bh=GBL+w+gKm4BciOel47s2fVIuHWYFXENW2ii/MuaXrB8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NZRsnGfw/AOrtXjMIy0XOgVBNrbz25Sh+zzn0MP8oLekKRW+9wHqm6KrfSzRtxZnE
	 gZnPKBgPMTwn6Ev6Wy2jLxCDV6QFmkHK/nte+la7lTFAdElsCTfxmbOiaHj1TC/+a4
	 n1STA9ZxgN9qeVTm3BNuVnYmfc22qvn+70FNmox1CFzGeOa1AwJJltekvnUAdTOB0d
	 +sakOwO7dExv4OV6hv+NYqX/s9kuMBGLtdgKdgyKrnX4xhlYOq37/GfUdJjR4PgyBS
	 tagaMzy4uDO4h+qJ35RwXZ9vwk/LZ9My6jf87EoReQcbJ/zP9HBr2FAY6O6R0OdiqD
	 1FtKaTqeLDBlQ==
Message-ID: <9d7a979a-59ad-4e88-964c-573b31778fff@kernel.org>
Date: Thu, 19 Nov 2026 06:03:51 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 2347/2651] gpiolib: Propagate emulated drive errors
 when setting arrays
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
 Sasha Levin <sashal@kernel.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150409.562185124@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261118150409.562185124@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18. 11. 26, 15:59, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Baek Kyu, Kim <pocj8ur4in@gmail.com>
> 
> [ Upstream commit 15665047024e30f9c2227563d03034061c99ac2c ]
> 
> gpiod_set_array_value_complex() ignores errors from the open-drain and
> open-source emulation helpers. If a direction change fails,
> GPIO_V2_LINE_SET_VALUES_IOCTL still reports success, including when
> updating a single line.
> 
> Return the first emulation error after freeing the temporary bitmaps.
> Keep updates already made to earlier lines and stop processing the
> remaining lines, as for errors from gpiochip_set_multiple().
> 
> Fixes: 8ce258f62f90 ("gpiolib: make value setters have return values")
> Signed-off-by:

How much illegal is to have this without the author's proper S-O-B?

> Link: https://patch.msgid.link/20261020172601.221861-1-pocj8ur4in@gmail.com
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpio/gpiolib.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 9c05d36ccd74f..90731a547ed63 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -3950,9 +3950,13 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
>   			 * open drain and open source outputs are set individually
>   			 */
>   			if (test_bit(GPIOD_FLAG_OPEN_DRAIN, &desc->flags) && !raw) {
> -				gpio_set_open_drain_value_commit(desc, value);
> +				ret = gpio_set_open_drain_value_commit(desc, value);
> +				if (ret)
> +					goto cleanup_bitmap;
>   			} else if (test_bit(GPIOD_FLAG_OPEN_SOURCE, &desc->flags) && !raw) {
> -				gpio_set_open_source_value_commit(desc, value);
> +				ret = gpio_set_open_source_value_commit(desc, value);
> +				if (ret)
> +					goto cleanup_bitmap;
>   			} else {
>   				__set_bit(hwgpio, mask);
>   				__assign_bit(hwgpio, bits, value);

-- 
js
suse labs

