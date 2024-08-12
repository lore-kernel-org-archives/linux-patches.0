Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB196134AC;
	Mon, 12 Aug 2024 16:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479787; cv=none; b=BTF+/YeJpff8JZnkSwwwstuo3Xe1POoSFNsQ7K/R4eHRefNHxzwOvL9XHdltc5V/6iP34r+5D4W0VXhAoQpf6LOorpO3S5eitGbuK/SjtL5HQxk1XZS0SnYuDDty+BYAMJ6lJIsfjGbBLS4pA0qLa8QgJUUb/bC++ceTeivOM5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479787; c=relaxed/simple;
	bh=BS5J1MDa3EAoXS/UpQ+j5b3TdaN6azO0mLgs2S/1ms4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIPawd9BKE4Q7QnlBGtNNZe6Ql+9Qrc3SlUIaAf1cqm993luHcWz24wIa0zlDci5xHnNbY6QVDEpJR0cVYGxAw8QT751jV+1siyBhVDCnWnVCl19Mlcss2jQnmCkNMJ/ibCYk5Xc9ZyKDAj7Ue8afBECoOBSmQ/gLSYA/uzyq6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqrWrl4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqrWrl4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB85C32782;
	Mon, 12 Aug 2024 16:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479787;
	bh=BS5J1MDa3EAoXS/UpQ+j5b3TdaN6azO0mLgs2S/1ms4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqrWrl4Je884r8BQl/03l1wmvTmTPb16efiMu/piEs9iDPMihRYbu9lQ+xzmr9Ufi
	 3ayPsfaXTNMjwRIt4euyBH+qQv1p5rfDFchYj+3zUscMQycKTEhOpr7uUzDrpTEFRA
	 WxPoKz3WYs9DeRp+MDoSPQ9H96EWhTGIRKcM31rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.6 164/189] drm/mgag200: Set DDC timeout in milliseconds
Date: Mon, 12 Aug 2024 18:03:40 +0200
Message-ID: <20240812160138.456578699@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit ecde5db1598aecab54cc392282c15114f526f05f upstream.

Compute the i2c timeout in jiffies from a value in milliseconds. The
original values of 2 jiffies equals 2 milliseconds if HZ has been
configured to a value of 1000. This corresponds to 2.2 milliseconds
used by most other DRM drivers. Update mgag200 accordingly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: 414c45310625 ("mgag200: initial g200se driver (v2)")
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v3.5+
Link: https://patchwork.freedesktop.org/patch/msgid/20240513125620.6337-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/mgag200/mgag200_i2c.c
+++ b/drivers/gpu/drm/mgag200/mgag200_i2c.c
@@ -115,7 +115,7 @@ int mgag200_i2c_init(struct mga_device *
 	i2c->adapter.algo_data = &i2c->bit;
 
 	i2c->bit.udelay = 10;
-	i2c->bit.timeout = 2;
+	i2c->bit.timeout = usecs_to_jiffies(2200);
 	i2c->bit.data = i2c;
 	i2c->bit.setsda		= mga_gpio_setsda;
 	i2c->bit.setscl		= mga_gpio_setscl;


