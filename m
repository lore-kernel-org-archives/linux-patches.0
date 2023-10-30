Received: from out198-10.us.a.mail.aliyun.com (out198-10.us.a.mail.aliyun.com [47.90.198.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF901364;
	Mon, 30 Oct 2023 02:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=awinic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=awinic.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.123296|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.0512103-0.000464542-0.948325;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047201;MF=wangweidong.a@awinic.com;NM=1;PH=DS;RN=11;RT=11;SR=0;TI=SMTPD_---.VAhPcwq_1698632937;
Received: from ubuntu-VirtualBox..(mailfrom:wangweidong.a@awinic.com fp:SMTPD_---.VAhPcwq_1698632937)
          by smtp.aliyun-inc.com;
          Mon, 30 Oct 2023 10:29:02 +0800
From: wangweidong.a@awinic.com
To: nathan@kernel.org
Cc: alsa-devel@alsa-project.org,
	broonie@kernel.org,
	lgirdwood@gmail.com,
	llvm@lists.linux.dev,
	ndesaulniers@google.com,
	patches@lists.linux.dev,
	trix@redhat.com,
	wangweidong.a@awinic.com,
	liweilei@awinic.com,
	yijiangtao@awinic.com
Subject: Re: [PATCH] ASoC: codecs: aw88399: Fix -Wuninitialized in aw_dev_set_vcalb()
Date: Mon, 30 Oct 2023 10:28:56 +0800
Message-ID: <20231030022856.12355-1-wangweidong.a@awinic.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231027-asoc-aw88399-fix-wuninitialized-v1-1-b1044493e4cd@kernel.org>
References: <20231027-asoc-aw88399-fix-wuninitialized-v1-1-b1044493e4cd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi, Nathan

On Fri, 27 Oct 2023 09:54:25 -0700 nathan@kernel.org wrote:

> Clang warns (or errors with CONFIG_WERROR=y):

>  sound/soc/codecs/aw88399.c:441:18: error: variable 'vsense_select' is uninitialized when used here [-Werror,-Wuninitialized]
>    441 |         vsense_select = vsense_select & (~AW88399_VDSEL_MASK);
>        |                         ^~~~~~~~~~~~~
>  sound/soc/codecs/aw88399.c:431:28: note: initialize the variable 'vsense_select' to silence this warning
>    431 |         unsigned int vsense_select, vsense_value;
>        |                                   ^
>        |                                    = 0
>  1 error generated.

> This clearly should have been using the value received from
> regmap_read(). Use the correct variable to resolve the warning.

> Closes: https://github.com/ClangBuiltLinux/linux/issues/1952
> Fixes: 8ade6cc7e261 ("ASoC: codecs: Add aw88399 amplifier driver")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> sound/soc/codecs/aw88399.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Thank you very much for your patch.

Reviewed-by: Weidong Wang <wangweidong.a@awinic.com>

Best regards,
Weidong Wang
