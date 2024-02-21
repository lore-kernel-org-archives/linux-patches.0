Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812EA69D34;
	Wed, 21 Feb 2024 13:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521093; cv=none; b=R4mZ75d8cvfGpCyYLJmIYQwy4qiSFqPNkSDHh5LdLNbvtuvk2OrjsNphkcusWn2i6n2Q7TDRrt7zOKi20NkVoA9d+vnoTkzCm+aqNsH3h+eH8pj4HsJQqh23CdNGF/1xhMongwxQX76rcZ5uwqNu4eUZHKd2mIawLkhAbqhkMkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521093; c=relaxed/simple;
	bh=dZ4nkN4axFMcPJ7wJASVbL3qjIKUSpwC93fapJRRQqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4hZw+iukxdYKpmN6EH1XHSoX2D/DqPXe4j0TwfMDy4WohH7VFOmj+KWucYNYqVnrhFAO1m110ccv2K2+mh82qwC/Zmw1xeiKre0pOkQBf/HBW4iDc8+o6zVur7OUE4Xv4/IvZM4Pr5BZCrQLLA/SKD+PxofXp+R/VfRvpHdjoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AP5tZjsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AP5tZjsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E76C433C7;
	Wed, 21 Feb 2024 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521093;
	bh=dZ4nkN4axFMcPJ7wJASVbL3qjIKUSpwC93fapJRRQqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AP5tZjsgA15uhxxPZXh9poWnXIMIfJ0AxuUH/KLpbw3rIRUGO6lLusiGCpYGYb6Vc
	 UM5dbmTiY4LTbBP1o0w6+QsjZcMN/H0dxdq3NEcu5cgPw/nZ1vlyey2Cj73AJUqG4w
	 TThXWhgumEVHq/S5+Mqkh+sCWFmzQc3wmW9bFgv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 023/202] drivers: core: fix kernel-doc markup for dev_err_probe()
Date: Wed, 21 Feb 2024 14:05:24 +0100
Message-ID: <20240221125932.520626075@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 074b3aad307de6126fbac1fff4996d1034b48fee upstream.

There are two literal blocks there. Fix the markups, in order
to produce the right html output and solve those warnings:

	./drivers/base/core.c:4218: WARNING: Unexpected indentation.
	./drivers/base/core.c:4222: WARNING: Definition list ends without a blank line; unexpected unindent.
	./drivers/base/core.c:4223: WARNING: Block quote ends without a blank line; unexpected unindent.

Fixes: a787e5400a1c ("driver core: add device probe log helper")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3344,13 +3344,15 @@ define_dev_printk_level(_dev_info, KERN_
  * This helper implements common pattern present in probe functions for error
  * checking: print debug or error message depending if the error value is
  * -EPROBE_DEFER and propagate error upwards.
- * It replaces code sequence:
+ * It replaces code sequence::
  * 	if (err != -EPROBE_DEFER)
  * 		dev_err(dev, ...);
  * 	else
  * 		dev_dbg(dev, ...);
  * 	return err;
- * with
+ *
+ * with::
+ *
  * 	return dev_err_probe(dev, err, ...);
  *
  * Returns @err.


