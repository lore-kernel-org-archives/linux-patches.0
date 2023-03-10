Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7D823A1
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 08:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDDAC4339B;
	Fri, 10 Mar 2023 08:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678438058;
	bh=8OIu7w5/Qm1MD2KVThRTovTz0f9qZOkpY/+NF/2wECE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zNToo8VQ1vC2sP9YR0/rWu7yuLeqE5EsGePB3Cp76EkBaqUDjSgSeOxJlV5pgY9u1
	 gIScWOJC7dRHnqPk7Hbi1hCSKxS0bUQI0JZmsDTXk+nL/B8Yr4CPfPElcqReWszQiY
	 7GR2WzDDzVWJwCfUKuCpFVWMAJ51vNU6eNbecm/s=
Date: Fri, 10 Mar 2023 09:19:56 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Srini Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH 6.2 0512/1001] tty: serial: qcom-geni-serial: stop
 operations in progress at shutdown
Message-ID: <ZAroLFDc5nPWrFzl@kroah.com>
References: <20230307170022.094103862@linuxfoundation.org>
 <20230307170043.650684610@linuxfoundation.org>
 <CACMJSetcAiz6nwCdAuZekwOavZji8HfHOU4hv6d9xp9pE_zf+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACMJSetcAiz6nwCdAuZekwOavZji8HfHOU4hv6d9xp9pE_zf+g@mail.gmail.com>

On Tue, Mar 07, 2023 at 06:53:46PM +0100, Bartosz Golaszewski wrote:
> On Tue, 7 Mar 2023 at 18:32, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > [ Upstream commit d8aca2f96813d51df574a811eda9a2cbed00f261 ]
> >
> > We don't stop transmissions in progress at shutdown. This is fine with
> > FIFO SE mode but with DMA (support for which we'll introduce later) it
> > causes trouble so fix it now.
> >
> > Fixes: e83766334f96 ("tty: serial: qcom_geni_serial: No need to stop tx/rx on UART shutdown")
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> > Link: https://lore.kernel.org/r/20221229155030.418800-2-brgl@bgdev.pl
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/tty/serial/qcom_geni_serial.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
> > index 57f04f8bf5043..851a5d2133aa2 100644
> > --- a/drivers/tty/serial/qcom_geni_serial.c
> > +++ b/drivers/tty/serial/qcom_geni_serial.c
> > @@ -891,6 +891,8 @@ static int setup_fifos(struct qcom_geni_serial_port *port)
> >  static void qcom_geni_serial_shutdown(struct uart_port *uport)
> >  {
> >         disable_irq(uport->irq);
> > +       qcom_geni_serial_stop_tx(uport);
> > +       qcom_geni_serial_stop_rx(uport);
> >  }
> >
> 
> Greg,
> 
> Please drop this patch from all stable branches as it has caused a
> problem in current master and - once fixed - is only relevant for new
> (DMA) code.

Now dropped from all queues, thanks.

greg k-h
