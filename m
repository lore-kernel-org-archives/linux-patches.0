Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61E6136358;
	Tue, 10 Sep 2024 06:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725949950; cv=none; b=t1D+EgWgXCcNNpLncGRakzC9Po5DGUXJAmLJiV+wI9jsIQ6ZlosWyb1KPZxTsLTIF3Ip8yfjzejmrWEKu/qfwvoeYiu3z4YdG1XEmxdOoge2vpE4eyGMS/BKewkM69jptaZTAUW6T6OdNDg+AcKBZbhtHKLUgdh38ftpVhOPFDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725949950; c=relaxed/simple;
	bh=bpa8W3NjcJL1yAbX7z/ky/UwNP3JD/k2tvA5X+AJf9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Stbu1kQMcUJ4R/028U1qdogc0ChLZcFR+HY0NvRfKclht/SLnUS+Fvg9/NtsMfhsfSlMqvkKwB/aC40GyQRpV2FWqYOYMIT6sLCNzW+7W+d2qSmaZ0N+UAPWq0j5/qCZZM9emjqYGr9mBa2dbMRI3FlumoqMOtbmasvomrxYtMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-205909af9b5so40374935ad.3;
        Mon, 09 Sep 2024 23:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725949948; x=1726554748;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jECedyLwpWSi/LgRrXCCeEdPK7kyo5RLypA86tH+o+I=;
        b=pGQyrprnOLYYmCar9WGpActcxmVpp0BNMSohFPrn6ET55zi+Gg2D2SD2pSKSP1swfZ
         4ZkCvhGthtOhy8AJGXtZyNqS6LLmf7OXAlwJuC76dNyWFe9nr1RnIElEI0GGpEWjC6ye
         P0Qb7vAkKtPoFLEDCPl4OWqfyJR7kluzlTxjSc0n0a1vbUfGsv3vKMOay/O+cO6Mt6VV
         uYNfqo56xojtGMVyP1XDadYVaoOLA4QBiQ4wNvo+6G9daPJJb7keDTby9UJz7jBKoqzc
         2q4ZROLF9gSNYrQ4Lwptmg2HjhDCleZmTCBwwbwR/AesnulMNLVARxRyhjOX9RKIuKHb
         dEXw==
X-Forwarded-Encrypted: i=1; AJvYcCVVP0UaARbhkmoy5mI9dHSw4jnWsb9+CjU3yg9Kok9yGU0jgIvARD/BPTIpoCOnIq/MD/XkWbcCsw==@lists.linux.dev, AJvYcCXL+ye5DAu7kFsO0kMcxWg0t9j/KQeVy1v0JJ6kZetDSeC+f+2B+TMnw7JBMoUN7Zlee+CZ@lists.linux.dev
X-Gm-Message-State: AOJu0YzCQMUuriKPAYeJVy1Bk9tfmE7oonKZFyBES1V2Xnat44E6kDMR
	CmnCvrAPZ3yMbdSfW95LiQQiNKGIIwz7ylUWPHuZgmjLz64i6wo0Lo+Kk+h6gDiQMBOWQ6CGMFh
	DVy90rG4pn7LcXYPW630/jBZNEBe4AsUg
X-Google-Smtp-Source: AGHT+IEvMIvaSTbfqXCvRnmgvdVXjOwGK/Qnzvkw/rL/oJbx++LHi2AScRFYedF7Rmc2pswkfRM5I9huGGE8ps5yWv0=
X-Received: by 2002:a17:902:f605:b0:205:76d0:563b with SMTP id
 d9443c01a7336-206f035bc2emr166544305ad.0.1725949947878; Mon, 09 Sep 2024
 23:32:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240909-rockchip-canfd-clang-div-libcall-v1-1-c6037ea0bb2b@kernel.org>
In-Reply-To: <20240909-rockchip-canfd-clang-div-libcall-v1-1-c6037ea0bb2b@kernel.org>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Tue, 10 Sep 2024 15:32:15 +0900
Message-ID: <CAMZ6RqKA77BWAMxL4_iAcye78JXDGxGQcEd9BJg7uCL9EO11XA@mail.gmail.com>
Subject: Re: [PATCH net-next] can: rockchip_canfd: Use div_s64() in rkcanfd_timestamp_init()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, kernel@pengutronix.de, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Heiko Stuebner <heiko@sntech.de>, 
	linux-can@vger.kernel.org, netdev@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue. 10 Sep. 2024 at 01:24, Nathan Chancellor <nathan@kernel.org> wrote:
> When building with clang for a 32-bit target, such as arm, a libcall is
> generated when dividing the result of clocksource_cyc2ns(), which
> returns a signed 64-bit integer:
>
>   ERROR: modpost: "__aeabi_ldivmod" [drivers/net/can/rockchip/rockchip_canfd.ko] undefined!
>
> Use div_s64() to avoid generating the libcall.
>
> Fixes: 4e1a18bab124 ("can: rockchip_canfd: add hardware timestamping support")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> This does not happen with GCC, likely because it implements
> optimizations for division by a constant that clang does not implement.
> ---
>  drivers/net/can/rockchip/rockchip_canfd-timestamp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/rockchip/rockchip_canfd-timestamp.c b/drivers/net/can/rockchip/rockchip_canfd-timestamp.c
> index 81cccc5fd8384ee1fec919077db48632f0fe7cc2..4ca01d385ffffdeec964b7fd954d8ba3ba3a1381 100644
> --- a/drivers/net/can/rockchip/rockchip_canfd-timestamp.c
> +++ b/drivers/net/can/rockchip/rockchip_canfd-timestamp.c
> @@ -71,7 +71,7 @@ void rkcanfd_timestamp_init(struct rkcanfd_priv *priv)
>
>         max_cycles = div_u64(ULLONG_MAX, cc->mult);
>         max_cycles = min(max_cycles, cc->mask);
> -       work_delay_ns = clocksource_cyc2ns(max_cycles, cc->mult, cc->shift) / 3;
> +       work_delay_ns = div_s64(clocksource_cyc2ns(max_cycles, cc->mult, cc->shift), 3);

I was surprised at first to see div_s64() instead of div_u64(), but
clocksource_cyc2ns() indeed returns a s64. So this looks correct.

>         priv->work_delay_jiffies = nsecs_to_jiffies(work_delay_ns);
>         INIT_DELAYED_WORK(&priv->timestamp, rkcanfd_timestamp_work);

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
