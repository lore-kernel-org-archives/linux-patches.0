Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95431A70B
	for <patches@lists.linux.dev>; Mon, 20 Nov 2023 13:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; dkim=none
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: gregkh@linuxfoundation.org
Cc: djakov@kernel.org,konrad.dybcio@linaro.org,patches@lists.linux.dev,sashal@kernel.org,stable@vger.kernel.org,mgorny@gentoo.org,Holger
 =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Subject: Re: [PATCH 5.10 137/191] interconnect: qcom: sc7180: Set ACV
 enable_mask
In-Reply-To: <20231115204652.746475501@linuxfoundation.org>
Date: Mon, 20 Nov 2023 13:18:14 +0000
Organization: Gentoo
Message-ID: <87fs10k1ee.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This patch breaks the build for 5.10.201:

/var/tmp/portage/sys-kernel/gentoo-kernel-5.10.201/work/linux-5.10/drivers/=
interconnect/qcom/sc7180.c:158:10:
error: =E2=80=98struct qcom_icc_bcm=E2=80=99 has no member named =E2=80=98e=
nable_mask=E2=80=99
158 |         .enable_mask =3D BIT(3),
    |          ^~~~~~~~~~~
make[4]: ***
[/var/tmp/portage/sys-kernel/gentoo-kernel-5.10.201/work/linux-5.10/scripts=
/Makefile.build:286:
drivers/interconnect/qcom/sc7180.o] Error 1

Looks like d8630f050d3fd2079f8617dd6c00c6509109c755 ('interconnect:
qcom: Add support for mask-based BCMs') is missing from 5.10.x.

thanks,
sam
