Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626293;
	b=dFOIUBSo0qMzoGmTpG2QqxdnHnmxelUOmR/gqIJhg2yBaNd9cH/eT0126fz+CFHcWDOA
	 eec9Gr3ka55xUAE78KvgKarj5IXXmmPdDXgGkcax83l4Y+TY3PlzD6Bb7ytXnCauK0mCb
	 EJyrg6nE+uZur6zsF4OC2R4l2b4XW+ysxCXmpHIPapa792NqoN04U92IbZ/jGtG92IjI/
	 f9WegtnkkaNdgE96ji4DQd/10AmgxAbxQBpikNe5LB5jFKG0i/OJneka40yGFvomSqzdf
	 hh+B4jHgZbCmhhxVlN4yJVly1r5KfD5Mm+fBPvDwITl6BhWMFk7fgpmNN3D36DMrOJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dflN+A8jv4lPWLOLUAnTrZogW+YeObK0HNj0ceZ93OI=;
	b=E6s9jUoWfclM3+t7XwCfeYc3514Idkbx2QDOZTu0/HZTscM46cBJF7uoUkQNjcm8e134
	 8aTDyh6V7bb9/0o2Awfx86fL97E7B9awJSKoUO3wQPn7Lg/IUPL1YTfjGHPnnfgrbyXEJ
	 OJdvSEJi7qA6/EEocf9PhQjTOmgRW3WnxUgMsWHrkeA5paeaAlrGxMa6h7V/EBbl5i+yF
	 iTB57X6/gZJOqgrxahIxsHHdxE5cWeErC9aBEoQZOZRXQd2+0MHuZYesxdvt55D47Dpyn
	 wmeu5/RL2jiqEs5do7ELrBCRQFyqrKqr2nA2x+JRdF4pVSKhDyMaStU1qN67AeUi1OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="01PYtU/e";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D81606A31E;
	Wed, 25 Nov 2026 17:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01PYtU/e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278BC1F000CA;
	Wed, 25 Nov 2026 17:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626292;
	bh=dflN+A8jv4lPWLOLUAnTrZogW+YeObK0HNj0ceZ93OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01PYtU/eU+TD0OYGnupJKKDsHry3w8Kue4OGDuiN88H0rLy4Bx4fWHhneoQnu+94V
	 VryUiCYlvqWXlcepfxYBnaY0O33L7tJ5/5QA+IdhS+0WCNDWSBtCrPLypGStGekGHG
	 COeq4M4ff4vDbbjaR0AUkOetx8qY11vCyzZIjzbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sarmanow <as@discnull.de>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 794/816] iio: light: vcnl4035: Fix reversed ALS mode bit
Date: Wed, 25 Nov 2026 15:39:02 +0100
Message-ID: <20261125143907.551167900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sarmanow <as@discnull.de>

commit 6bcabc30b89f31e2925647d1ffa5a0e4b7919829 upstream.

According to the datasheet (table 2) the ALS_SD bit behaves the opposite
way the current ALS mode defines are set, writing 0 powers the sensor
and writing 1 shuts it down.

The current driver thinks the ALS is up while it's actually shut down
and it's down when the systems powers it up.

Fixes: 55707294c4eb ("iio: light: Add support for vishay vcnl4035")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sarmanow <as@discnull.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -46,8 +46,8 @@
 #define VCNL4035_DEV_ID_MASK		GENMASK(7, 0)
 
 /* Default values */
-#define VCNL4035_MODE_ALS_ENABLE	BIT(0)
-#define VCNL4035_MODE_ALS_DISABLE	0x00
+#define VCNL4035_MODE_ALS_ENABLE	0x00
+#define VCNL4035_MODE_ALS_DISABLE	BIT(0)
 #define VCNL4035_MODE_ALS_INT_ENABLE	BIT(1)
 #define VCNL4035_MODE_ALS_INT_DISABLE	0
 #define VCNL4035_DEV_ID_VAL		0x80


