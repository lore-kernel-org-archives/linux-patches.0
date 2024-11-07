Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3C21EE00C
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 11:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977735; cv=pass; b=CLBEbJ3VWrRmsFbNvfH935T1YYa2afuc/LasZ+D4Ku5UKWdrIJqEhZEb7grFSeJ9y80St048uSYukF9NVkHDYp1YXUWZ7VAh9g+TAuhe46XCaAkbsChEXez+u/YE6KY59w5pl95oQUMmbUgqvmJbRB37yi83KMINRw7k5GonSYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977735; c=relaxed/simple;
	bh=JkHvu85HJlQ/TrMLj2dhBxzs4doiMdJ/hIMmVZnIpV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NfBFEP1qR5gKuKFq8A+jduTxd+DiChSIqFZArcCyOr9SryE2lXufMuABOY87mh+gUGIEiV7RbTD1BE3jZFCOwDEa2x24WJusm4sZaoXvHZPMHmiuz8zEEEabguZjtjRmmKc1sxlGuldSbelJGp3ZgSysg0EHoHZHVoJgYHuZdiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=gFGzfb9T; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="gFGzfb9T"
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: martin-eric.racine)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4XkfT63NDjzyYJ
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 13:08:42 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1730977722; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzyxtAbtNG6GyT9iqf9QZI/qjZ0+BnzsW2+Prr6BSVQ=;
	b=gFGzfb9TKSkFfvcAyPaFj5C888QHu/Zyj6go0d283tK3rkkjuhDZPB0gqenBIKSg8o1Bec
	sM0go6257PZ+xP7sTLflUazutzIxDEzcXy2aNSGT2IcgpGZzuAVqxIQEVpo9wh2CByFJYe
	OZWgFv3wxTJ9vN/aXRXfWSzhKoQ5f3U=
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1730977722; a=rsa-sha256; cv=none;
	b=PYCfB1L2detrWuZDKCbZerZIpd7XM+WwRSjKzQ4MPHv8PzwdVZdBXh/YydkLZxN+hP5kjR
	Ywipd+CSioLgFSezOZxAKIK8oY7I61C3NNQHcWbTh/jh23Ma6KDtjn2JkEblmvdreBuaM1
	Zutdsd7JhTKG/3yziN6Uzvas4Ws1nBg=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=martin-eric.racine smtp.mailfrom=martin-eric.racine@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1730977722;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzyxtAbtNG6GyT9iqf9QZI/qjZ0+BnzsW2+Prr6BSVQ=;
	b=JJmwlm83rNmlGJIZ8lhS3cBKijaAopT2mCSwx/IBlQxkdjKElyJT2Iu3g4kiLWEHZPyu9q
	8dbKmlU3J5ilfTzKk1/5iH7gYxsUXXSf8p6ikqO44ivjrvPn6iRQ/fcjE7VUTnomNxnScj
	aWdWjfnbHQbEmqtJqOA1wXK7MSLcpQs=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4319399a411so7351205e9.2
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 03:08:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXKj4JrfVXyYIRx27pEImzc1X3sWtKxBP1IyIGAiwa6klg0+3jM5HYXlqtPp+0TmlvnWM6b61P8@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/7wR0940tO0VeJntqh4OdODSWlTiZUVccmTj5x/ytkS4WfBw3
	ltqctcwcRTlZ3fVdo05g5tI76NiEFuOMnm68pBMurmY2tGqfvmxS919I21dCjv9Ul4s2pq7B6nz
	naV3mE+fzAlRlH+5lHj0rOHsX548=
X-Google-Smtp-Source: AGHT+IEC1v/bHHqQvzS7SMppJ6Vp61ZWG0NG33xBhJlhNJvSvPAIWpt0NOho6ZGAz6Ltvzjlgf3lc4NBTRCiI0NUB64=
X-Received: by 2002:a05:600c:4fcb:b0:426:5269:1a50 with SMTP id
 5b1f17b1804b1-4319ac9c15fmr358610065e9.11.1730977721129; Thu, 07 Nov 2024
 03:08:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120319.234238499@linuxfoundation.org> <20241106120319.473879944@linuxfoundation.org>
In-Reply-To: <20241106120319.473879944@linuxfoundation.org>
Reply-To: martin-eric.racine@iki.fi
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
Date: Thu, 7 Nov 2024 13:08:29 +0200
X-Gmail-Original-Message-ID: <CAPZXPQessspMxh1Lc2EeHEwMFLsvWF71waz2=LjZ4W3MVdWx2A@mail.gmail.com>
Message-ID: <CAPZXPQessspMxh1Lc2EeHEwMFLsvWF71waz2=LjZ4W3MVdWx2A@mail.gmail.com>
Subject: Re: [PATCH 6.11 009/245] wifi: iwlegacy: Fix "field-spanning write"
 warning in il_enqueue_hcmd()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Ben Hutchings <ben@decadent.org.uk>, Brandon Nielsen <nielsenb@jetfuse.net>, 
	Stanislaw Gruszka <stf_xl@wp.pl>, Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applies cleanly to 6.11.6 and fixes the kernel oops.

ke 6. marrask. 2024 klo 14.26 Greg Kroah-Hartman
(gregkh@linuxfoundation.org) kirjoitti:
>
> 6.11-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Ben Hutchings <ben@decadent.org.uk>
>
> [ Upstream commit d4cdc46ca16a5c78b36c5b9b6ad8cac09d6130a0 ]
>
> iwlegacy uses command buffers with a payload size of 320
> bytes (default) or 4092 bytes (huge).  The struct il_device_cmd type
> describes the default buffers and there is no separate type describing
> the huge buffers.
>
> The il_enqueue_hcmd() function works with both default and huge
> buffers, and has a memcpy() to the buffer payload.  The size of
> this copy may exceed 320 bytes when using a huge buffer, which
> now results in a run-time warning:
>
>     memcpy: detected field-spanning write (size 1014) of single field "&o=
ut_cmd->cmd.payload" at drivers/net/wireless/intel/iwlegacy/common.c:3170 (=
size 320)
>
> To fix this:
>
> - Define a new struct type for huge buffers, with a correctly sized
>   payload field
> - When using a huge buffer in il_enqueue_hcmd(), cast the command
>   buffer pointer to that type when looking up the payload field
>
> Reported-by: Martin-=C3=89ric Racine <martin-eric.racine@iki.fi>
> References: https://bugs.debian.org/1062421
> References: https://bugzilla.kernel.org/show_bug.cgi?id=3D219124
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Fixes: 54d9469bc515 ("fortify: Add run-time WARN for cross-field memcpy()=
")
> Tested-by: Martin-=C3=89ric Racine <martin-eric.racine@iki.fi>
> Tested-by: Brandon Nielsen <nielsenb@jetfuse.net>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
> Signed-off-by: Kalle Valo <kvalo@kernel.org>
> Link: https://patch.msgid.link/ZuIhQRi/791vlUhE@decadent.org.uk
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/wireless/intel/iwlegacy/common.c | 13 ++++++++++++-
>  drivers/net/wireless/intel/iwlegacy/common.h | 12 ++++++++++++
>  2 files changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/w=
ireless/intel/iwlegacy/common.c
> index 9d33a66a49b59..4616293ec0cf4 100644
> --- a/drivers/net/wireless/intel/iwlegacy/common.c
> +++ b/drivers/net/wireless/intel/iwlegacy/common.c
> @@ -3122,6 +3122,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_=
cmd *cmd)
>         struct il_cmd_meta *out_meta;
>         dma_addr_t phys_addr;
>         unsigned long flags;
> +       u8 *out_payload;
>         u32 idx;
>         u16 fix_size;
>
> @@ -3157,6 +3158,16 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host=
_cmd *cmd)
>         out_cmd =3D txq->cmd[idx];
>         out_meta =3D &txq->meta[idx];
>
> +       /* The payload is in the same place in regular and huge
> +        * command buffers, but we need to let the compiler know when
> +        * we're using a larger payload buffer to avoid "field-
> +        * spanning write" warnings at run-time for huge commands.
> +        */
> +       if (cmd->flags & CMD_SIZE_HUGE)
> +               out_payload =3D ((struct il_device_cmd_huge *)out_cmd)->c=
md.payload;
> +       else
> +               out_payload =3D out_cmd->cmd.payload;
> +
>         if (WARN_ON(out_meta->flags & CMD_MAPPED)) {
>                 spin_unlock_irqrestore(&il->hcmd_lock, flags);
>                 return -ENOSPC;
> @@ -3170,7 +3181,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_=
cmd *cmd)
>                 out_meta->callback =3D cmd->callback;
>
>         out_cmd->hdr.cmd =3D cmd->id;
> -       memcpy(&out_cmd->cmd.payload, cmd->data, cmd->len);
> +       memcpy(out_payload, cmd->data, cmd->len);
>
>         /* At this point, the out_cmd now has all of the incoming cmd
>          * information */
> diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/w=
ireless/intel/iwlegacy/common.h
> index 69687fcf963fc..027dae5619a37 100644
> --- a/drivers/net/wireless/intel/iwlegacy/common.h
> +++ b/drivers/net/wireless/intel/iwlegacy/common.h
> @@ -560,6 +560,18 @@ struct il_device_cmd {
>
>  #define TFD_MAX_PAYLOAD_SIZE (sizeof(struct il_device_cmd))
>
> +/**
> + * struct il_device_cmd_huge
> + *
> + * For use when sending huge commands.
> + */
> +struct il_device_cmd_huge {
> +       struct il_cmd_header hdr;       /* uCode API */
> +       union {
> +               u8 payload[IL_MAX_CMD_SIZE - sizeof(struct il_cmd_header)=
];
> +       } __packed cmd;
> +} __packed;
> +
>  struct il_host_cmd {
>         const void *data;
>         unsigned long reply_page;
> --
> 2.43.0
>
>
>
