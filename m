Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38460BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:53:58 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-5384ff97993so259240837b3.2
        for <patches@lists.linux.dev>; Tue, 07 Mar 2023 09:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678211637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vy6L+eQJroBciwKL8scsNnpdjChAQfq3YHv0JMCXPSo=;
        b=e5jG2hZtedpCOzEhX3MKhD2DImjqtaX15SiOuwdCp9uhYmlrOC0ZWMmPQPK68zJvoR
         XAj79c72bwCV4qcDZN4rxzSoygjodATifVd6Mk9QlbhHnyrmLohklKUhfg2DZWAly8wV
         6ifUxWO7zlteysiu8qU8w3Z/5p67GRMwD32FqGakfwE1ynRAeOcrN7NtuK/A57l6/VnZ
         JA5CdR256HdyzLj5lvV9ndzOcBthtH44FOfiBa0hqfLztygvBVoP7+VtuCBM2la3+Gum
         8cK2z7glwwN8l9FX080OVnwFSMwEuM2YXUKzFIZ0VA/zUP/6fj+dNkEoc823vHWgyBHR
         x0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678211637;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vy6L+eQJroBciwKL8scsNnpdjChAQfq3YHv0JMCXPSo=;
        b=QTTa3bqcYfU3Z7uJQykHHDF542kqY7jFhX+y24u/6vpo+cghlDflzECX0SXxKimPm+
         ADwu/doW+yWtYPN7W8C5SvuNZIb4Zo5p9tQqNChp/2k89Q64S1MbLsGDTosdbw48gUBH
         NKPVxOoqrwucb94QiYHHQVAoXK0TZm+zbWaOj4x1+WYfop60CsFipqql9pQCsdT1a9lE
         lSGLvvP9ZGa7FLGIK1fepeP7mDLJeV3qED4L3OEeUAMZBj0JO2z3AznTUGabP0hBmf5o
         k9SDPfkDXxhyc29YQrmj/dF9OZZW0vN+YTtVpdaMIkTeESpZaj5B11DG4/zS3Narbd7Z
         aI6w==
X-Gm-Message-State: AO0yUKWDi/kIrcCYS4Yy1G9lJNf+VjnME2P1i6focSMRpEuAcHsXQWR3
	yxK7WKCnXYv3z47u90CXDiZhU1f98Gs2DYBnYfkAtg==
X-Google-Smtp-Source: AK7set9FjQy7hM69scJN/x0IXxD69J1rqAnvHqJd628maJ126bk1Sb0clpk6+IRyjQ2IH0NlkuU6hicsP0uUb0Jre6E=
X-Received: by 2002:a81:ac59:0:b0:52e:bb3e:15aa with SMTP id
 z25-20020a81ac59000000b0052ebb3e15aamr9163642ywj.7.1678211637049; Tue, 07 Mar
 2023 09:53:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230307170022.094103862@linuxfoundation.org> <20230307170043.650684610@linuxfoundation.org>
In-Reply-To: <20230307170043.650684610@linuxfoundation.org>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Tue, 7 Mar 2023 18:53:46 +0100
Message-ID: <CACMJSetcAiz6nwCdAuZekwOavZji8HfHOU4hv6d9xp9pE_zf+g@mail.gmail.com>
Subject: Re: [PATCH 6.2 0512/1001] tty: serial: qcom-geni-serial: stop
 operations in progress at shutdown
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Sasha Levin <sashal@kernel.org>, 
	Johan Hovold <johan+linaro@kernel.org>, Srini Kandagatla <srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 Mar 2023 at 18:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> [ Upstream commit d8aca2f96813d51df574a811eda9a2cbed00f261 ]
>
> We don't stop transmissions in progress at shutdown. This is fine with
> FIFO SE mode but with DMA (support for which we'll introduce later) it
> causes trouble so fix it now.
>
> Fixes: e83766334f96 ("tty: serial: qcom_geni_serial: No need to stop tx/rx on UART shutdown")
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Link: https://lore.kernel.org/r/20221229155030.418800-2-brgl@bgdev.pl
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/tty/serial/qcom_geni_serial.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
> index 57f04f8bf5043..851a5d2133aa2 100644
> --- a/drivers/tty/serial/qcom_geni_serial.c
> +++ b/drivers/tty/serial/qcom_geni_serial.c
> @@ -891,6 +891,8 @@ static int setup_fifos(struct qcom_geni_serial_port *port)
>  static void qcom_geni_serial_shutdown(struct uart_port *uport)
>  {
>         disable_irq(uport->irq);
> +       qcom_geni_serial_stop_tx(uport);
> +       qcom_geni_serial_stop_rx(uport);
>  }
>

Greg,

Please drop this patch from all stable branches as it has caused a
problem in current master and - once fixed - is only relevant for new
(DMA) code.

Bartosz
