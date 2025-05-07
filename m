Received: from hsmtpd-dty.xspmail.jp (hsmtpd-dty.xspmail.jp [210.130.137.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6B6223DF1
	for <patches@lists.linux.dev>; Wed,  7 May 2025 13:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.130.137.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746624128; cv=none; b=L5Xchm3iYbZTcotPqmToQOWJJBLsCbNe/pvH+Uk1Cv7baWMiP3X1wLMAcdHZ7K1tNeTe8pCxxoj7HsNaPmlJURPV/R6NhRvsahmA3FTpXY26/WylYKhO+qWZU57CAI4Dnqb79rcoUuJqfDr6Eh5f06WdimgKWk5eq9k9G8Qo8pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746624128; c=relaxed/simple;
	bh=JxnWroRdd5eSzJwWJo9jy1HPvEV+AYZ+Nc3gtYKtK0M=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=py5HD261JXkF34Edek8UN+d2OdZFDRz1X9gJL6Cy2aAMSdvoxn0oiC0VATx0McUFXCzPPG8jmailRtTB7HoBF8OBu74cxR+K07MvMK65ry2+ucKD/oq9fxbV8zMbj5fO3oJL0Om846X2I7538U4A2qfz1G+Yj/loQZBimbWLFp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iijmio-mail.jp; spf=pass smtp.mailfrom=iijmio-mail.jp; dkim=pass (2048-bit key) header.d=iijmio-mail.jp header.i=henrich@iijmio-mail.jp header.b=KsAnflkB; arc=none smtp.client-ip=210.130.137.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iijmio-mail.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iijmio-mail.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iijmio-mail.jp header.i=henrich@iijmio-mail.jp header.b="KsAnflkB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1746624123;
	d=iijmio-mail.jp; s=x01; i=henrich@iijmio-mail.jp;
	h=content-type:mime-version:references:in-reply-to:message-id:subject:cc:to:
	 from:date:from;
	bh=4alyGvrc/7xpYSa+30dMx3re9Jlt3ucr/f0nBKDIg9s=;
	b=KsAnflkBEt4iorRhDmacRgnd4uYfiij7jxh/wcHMFhCW/JCjqdOfUtCEKS+YbhU6NItsB3rxNtS3b
	 FYCd1tmzzRJTBMI9/7NTqNtYL76ubF+UacTCnGNjcgTGiH5KyGy2921zMMhPWON3vupGGRVn7+wijO
	 Nr9TFOC/Zcz0exY3nWOqQ5zjRIckfRaP3mgdtGZEf/f3xydjMlsiHtjcSrQbIyUlxLEIqAw4HWMDeN
	 TzoQUdzgRpykxhQa5j3NqHQD2gQP1wfOYwoZPeCt5+eurh00/x3EW73rQz7huXrR7VIljBGWgiiG+O
	 9anw7IheHRzjLyJqS35V+1eOmp/FAkA==
X-Country-Code: JP
Received: from t14s (unknown [2409:12:b80:1600:5410:436b:3e69:1281])
	by hsmtpd-out-1.iij.cluster.xspmail.jp (Halon) with ESMTPSA (TLSv1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	id 92b8e8f7-07ec-44b8-8398-821dc2a5141d;
	Wed, 07 May 2025 22:22:03 +0900 (JST)
Date: Wed, 7 May 2025 22:21:56 +0900
From: Hideki Yamane <henrich@iijmio-mail.jp>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Sergey Shtylyov
 <s.shtylyov@omp.ru>, Rob Herring <robh@kernel.org>, Uwe
 =?UTF-8?B?S2xlaW5lLUvDg8K2bmln?= <ukleinek@debian.org>, h-yamane@sios.com
Subject: Re: [PATCH 6.1 150/167] of: module: add buffer overflow check in
 of_modalias()
Message-Id: <20250507222156.6c59459565246dc1b5ae37fc@iijmio-mail.jp>
In-Reply-To: <2025050737-banked-clarify-3bf8@gregkh>
References: <20250429161051.743239894@linuxfoundation.org>
	<20250429161057.791863253@linuxfoundation.org>
	<20250507200533.ac131fe0c774b23054b4261e@iijmio-mail.jp>
	<2025050737-banked-clarify-3bf8@gregkh>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__7_May_2025_22_21_56_+0900_peyc_M10DDXbA/3F"

This is a multi-part message in MIME format.

--Multipart=_Wed__7_May_2025_22_21_56_+0900_peyc_M10DDXbA/3F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 May 2025 13:12:02 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> It does not apply there cleanly, please submit tested patches against
> those branches if you wish to have it applied there.

 Diff attached, and built fine with those patches and corresponded branches
 on my laptop. Those changes just adds checks for length, so I guess no harm
 with that.


 I'm not familiar with Linux kernel development (my previous 1-liner patch
 was merged 20 years ago ;) so maybe I did something wrong again, please
 point out, then. Thank you.

-- 
Hideki Yamane <henrich@iijmio-mail.jp / debian.org | h-yamane@sios.com>

--Multipart=_Wed__7_May_2025_22_21_56_+0900_peyc_M10DDXbA/3F
Content-Type: text/x-diff;
 name="0001-of-module-add-buffer-overflow-check-in-of_modalias_for-5.4.y.patch"
Content-Disposition: attachment;
 filename="0001-of-module-add-buffer-overflow-check-in-of_modalias_for-5.4.y.patch"
Content-Transfer-Encoding: quoted-printable

From 0c6f88bd0ec71dccb358d9b969abee22d9d9f6cd Mon Sep 17 00:00:00 2001
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Date: Sun, 14 Apr 2024 11:51:39 +0300
Subject: [PATCH] of: module: add buffer overflow check in of_modalias()
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

commit cf7385cb26ac4f0ee6c7385960525ad534323252 upstream.

In of_modalias(), if the buffer happens to be too small even for the 1st
snprintf() call, the len parameter will become negative and str parameter
(if not NULL initially) will point beyond the buffer's end. Add the buffer
overflow check after the 1st snprintf() call and fix such check after the
strlen() call (accounting for the terminating NUL char).

Fixes: bc575064d688 ("of/device: use of_property_for_each_string to parse c=
ompatible strings")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/bbfc6be0-c687-62b6-d015-5141b93f313e@omp.ru
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Uwe Kleine-K=C3=B6nig <ukleinek@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/device.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 7fb870097a84..ee3467730dac 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -213,14 +213,15 @@ static ssize_t of_device_get_modalias(struct device *=
dev, char *str, ssize_t len
 	csize =3D snprintf(str, len, "of:N%pOFn%c%s", dev->of_node, 'T',
 			 of_node_get_device_type(dev->of_node));
 	tsize =3D csize;
+	if (csize >=3D len)
+		csize =3D len > 0 ? len - 1 : 0;
 	len -=3D csize;
-	if (str)
-		str +=3D csize;
+	str +=3D csize;
=20
 	of_property_for_each_string(dev->of_node, "compatible", p, compat) {
 		csize =3D strlen(compat) + 1;
 		tsize +=3D csize;
-		if (csize > len)
+		if (csize >=3D len)
 			continue;
=20
 		csize =3D snprintf(str, len, "C%s", compat);
--=20
2.47.2


--Multipart=_Wed__7_May_2025_22_21_56_+0900_peyc_M10DDXbA/3F
Content-Type: text/x-diff;
 name="0001-of-module-add-buffer-overflow-check-in-of_modalias_for-5.10.y.patch"
Content-Disposition: attachment;
 filename="0001-of-module-add-buffer-overflow-check-in-of_modalias_for-5.10.y.patch"
Content-Transfer-Encoding: quoted-printable

From ecc1a605db01948a72effe99f4e866c640e28211 Mon Sep 17 00:00:00 2001
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Date: Sun, 14 Apr 2024 11:51:39 +0300
Subject: [PATCH] of: module: add buffer overflow check in of_modalias()
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

commit cf7385cb26ac4f0ee6c7385960525ad534323252 upstream.

In of_modalias(), if the buffer happens to be too small even for the 1st
snprintf() call, the len parameter will become negative and str parameter
(if not NULL initially) will point beyond the buffer's end. Add the buffer
overflow check after the 1st snprintf() call and fix such check after the
strlen() call (accounting for the terminating NUL char).

Fixes: bc575064d688 ("of/device: use of_property_for_each_string to parse c=
ompatible strings")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/bbfc6be0-c687-62b6-d015-5141b93f313e@omp.ru
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Uwe Kleine-K=C3=B6nig <ukleinek@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/device.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 3a547793135c..93f08f18f6b3 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -231,14 +231,15 @@ static ssize_t of_device_get_modalias(struct device *=
dev, char *str, ssize_t len
 	csize =3D snprintf(str, len, "of:N%pOFn%c%s", dev->of_node, 'T',
 			 of_node_get_device_type(dev->of_node));
 	tsize =3D csize;
+	if (csize >=3D len)
+		csize =3D len > 0 ? len - 1 : 0;
 	len -=3D csize;
-	if (str)
-		str +=3D csize;
+	str +=3D csize;
=20
 	of_property_for_each_string(dev->of_node, "compatible", p, compat) {
 		csize =3D strlen(compat) + 1;
 		tsize +=3D csize;
-		if (csize > len)
+		if (csize >=3D len)
 			continue;
=20
 		csize =3D snprintf(str, len, "C%s", compat);
--=20
2.47.2


--Multipart=_Wed__7_May_2025_22_21_56_+0900_peyc_M10DDXbA/3F
Content-Type: text/x-diff;
 name="0001-of-module-add-buffer-overflow-check-in-of_modalias_for-5.15.y.patch"
Content-Disposition: attachment;
 filename="0001-of-module-add-buffer-overflow-check-in-of_modalias_for-5.15.y.patch"
Content-Transfer-Encoding: quoted-printable

From f28ebf105a327a1d6e476e250a3904ca33eb47fb Mon Sep 17 00:00:00 2001
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Date: Sun, 14 Apr 2024 11:51:39 +0300
Subject: [PATCH] of: module: add buffer overflow check in of_modalias()
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

commit cf7385cb26ac4f0ee6c7385960525ad534323252 upstream.

In of_modalias(), if the buffer happens to be too small even for the 1st
snprintf() call, the len parameter will become negative and str parameter
(if not NULL initially) will point beyond the buffer's end. Add the buffer
overflow check after the 1st snprintf() call and fix such check after the
strlen() call (accounting for the terminating NUL char).

Fixes: bc575064d688 ("of/device: use of_property_for_each_string to parse c=
ompatible strings")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/bbfc6be0-c687-62b6-d015-5141b93f313e@omp.ru
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Uwe Kleine-K=C3=B6nig <ukleinek@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/device.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 19c42a9dcba9..f503bb10b10b 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -257,14 +257,15 @@ static ssize_t of_device_get_modalias(struct device *=
dev, char *str, ssize_t len
 	csize =3D snprintf(str, len, "of:N%pOFn%c%s", dev->of_node, 'T',
 			 of_node_get_device_type(dev->of_node));
 	tsize =3D csize;
+	if (csize >=3D len)
+		csize =3D len > 0 ? len - 1 : 0;
 	len -=3D csize;
-	if (str)
-		str +=3D csize;
+	str +=3D csize;
=20
 	of_property_for_each_string(dev->of_node, "compatible", p, compat) {
 		csize =3D strlen(compat) + 1;
 		tsize +=3D csize;
-		if (csize > len)
+		if (csize >=3D len)
 			continue;
=20
 		csize =3D snprintf(str, len, "C%s", compat);
--=20
2.47.2


--Multipart=_Wed__7_May_2025_22_21_56_+0900_peyc_M10DDXbA/3F--
