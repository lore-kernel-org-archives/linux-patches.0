Received: from newton.telenet-ops.be (newton.telenet-ops.be [195.130.132.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028AB48D0
	for <patches@lists.linux.dev>; Tue,  8 Mar 2022 14:27:19 +0000 (UTC)
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
	by newton.telenet-ops.be (Postfix) with ESMTPS id 4KCcq55bsNzMqjVS
	for <patches@lists.linux.dev>; Tue,  8 Mar 2022 15:17:37 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:6100:2d37:4115:c358])
	by albert.telenet-ops.be with bizsmtp
	id 3qHT270081Yj8bA06qHTJB; Tue, 08 Mar 2022 15:17:30 +0100
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.93)
	(envelope-from <geert@linux-m68k.org>)
	id 1nRaeU-003Bwf-Oo; Tue, 08 Mar 2022 15:17:26 +0100
Date: Tue, 8 Mar 2022 15:17:26 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To: Nathan Chancellor <nathan@kernel.org>
cc: Wolfram Sang <wsa@kernel.org>, 
    Jarkko Nikula <jarkko.nikula@linux.intel.com>, 
    Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
    Mika Westerberg <mika.westerberg@linux.intel.com>, 
    Jan Dabros <jsd@semihalf.com>, Hans de Goede <hdegoede@redhat.com>, 
    linux-i2c@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH -next] i2c: designware: Mark dw_i2c_plat_{suspend,resume}()
 as __maybe_unused
In-Reply-To: <20220303191713.2402461-1-nathan@kernel.org>
Message-ID: <alpine.DEB.2.22.394.2203081513270.760560@ramsan.of.borg>
References: <20220303191713.2402461-1-nathan@kernel.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 3 Mar 2022, Nathan Chancellor wrote:
> When CONFIG_PM is set but CONFIG_PM_SLEEP is not, two compiler warnings
> appear:
>
>  drivers/i2c/busses/i2c-designware-platdrv.c:444:12: error: unused function 'dw_i2c_plat_suspend' [-Werror,-Wunused-function]
>  static int dw_i2c_plat_suspend(struct device *dev)
>             ^
>  drivers/i2c/busses/i2c-designware-platdrv.c:465:12: error: unused function 'dw_i2c_plat_resume' [-Werror,-Wunused-function]
>  static int dw_i2c_plat_resume(struct device *dev)
>             ^
>  2 errors generated.
>
> These functions are only used in SET_LATE_SYSTEM_SLEEP_PM_OPS(), which
> is defined as empty when CONFIG_PM_SLEEP is not defined. Mark the
> functions as __maybe_unused to make it clear that these functions might
> be unused in this configuration.
>
> Fixes: c57813b8b288 ("i2c: designware: Lock the adapter while setting the suspended flag")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

As I just ran into this myself...

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
