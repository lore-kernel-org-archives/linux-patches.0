Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208508;
	b=2GY/H1DapqJFqFinccJGjHIqcci35fPtk82kofSFFDHmuEIl0c9gu3BwqO91e/1KEela
	 u0K6ovMLfZ1FvGMz9CABlMUCjGAPmiClEjvK5Eo/JQtG59Su9LEzkmYlufbE1iMvmtm2/
	 QT0h8Ljd3mACuqwtAZDbykCGpdyNlojrKLzQAuf595yEt6R7Tw0xSEOFvXNgRuRPbtre/
	 speYZXHeZX/lGVLy8C/t+VFcylgTkHyEwfcR7KKycMvFEKII63BihgplNwb+JFpHZ7Jp+
	 /fvOAr5VSL9IrJg3ab/eaxi/wL7O0pBkEmDy34sEhM56iIKhTQdfpZ0JKs6uZEiyA4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2JWehdaIi1++odRmYhQXh1WOHaA4PXuDZAUxOzNZi3U=;
	b=YWyzTyB+0c+TAyFTH9y5IA3hZ6P75050h2YIHDFS0tYeb6OJBlmmZPH0YQ6c0Gn2iiE9
	 /6+GloaHeVIUw0355fkrTD0JSW+J2C2egMX9Y1mDf5nj0zGjDEG9DbIeROiX7muHItrIr
	 ys4Oc40dIoYE/WngjG71gctQSljUezTuUQZ7N5gi9qtBgcksJWyLjEt1k6pWxZvNsUAYm
	 rZ+akk/js56U4GDdkoU9VXH5jUwL5z2Usoh0i9Gr27uVy5GcqxCaZ481PgeXDGphNZ3ov
	 ux8+/wHtw1ctmFTBMSDQkrgpzXmzV1Rqqn7m1ZtiDkPipeJ9CsWzUX8an39fxH/wO+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGxvFKXA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389E1606A31E;
	Wed, 28 Oct 2026 17:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGxvFKXA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E7B1F01825;
	Wed, 28 Oct 2026 17:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208508;
	bh=2JWehdaIi1++odRmYhQXh1WOHaA4PXuDZAUxOzNZi3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGxvFKXA06rvsL1jdvNvfvc/yWDj0mvs42wAopil09MrRo11LJiSdprD2ZVA8oFHa
	 /jKH/nZ+Sh8h7uQdpcNqyUG0Hzwqi0GAau7MkG+T+e9zZJXR+cEp5u5Jymu8YEqo9n
	 QDb+1Xbp2DVojAmbOZzFDUmhjmFl0HyfjlQB153c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/516] devm-helpers: Add resource managed version of work init
Date: Wed, 28 Oct 2026 17:54:13 +0100
Message-ID: <20261028170005.913925115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 7a2c4cc537fa9f05fe90812e7d789b9faf7eb869 ]

A few drivers which need a work-queue must cancel work at driver detach.
Some of those implement remove() solely for this purpose. Help drivers to
avoid unnecessary remove and error-branch implementation by adding managed
verision of work initialization. This will also help drivers to avoid
mixing manual and devm based unwinding when other resources are handled by
devm.

Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/94ff4175e7f2ff134ed2fa7d6e7641005cc9784b.1623146580.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: a2471ed17b0e ("hwmon: (gpio-fan) Fix use-after-free in alarm work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/devm-helpers.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/devm-helpers.h b/include/linux/devm-helpers.h
index f64e0c9f3763c..50557f04ce802 100644
--- a/include/linux/devm-helpers.h
+++ b/include/linux/devm-helpers.h
@@ -50,4 +50,29 @@ static inline int devm_delayed_work_autocancel(struct device *dev,
 	return devm_add_action(dev, devm_delayed_work_drop, w);
 }
 
+static inline void devm_work_drop(void *res)
+{
+	cancel_work_sync(res);
+}
+
+/**
+ * devm_work_autocancel - Resource-managed work allocation
+ * @dev:	Device which lifetime work is bound to
+ * @w:		Work to be added (and automatically cancelled)
+ * @worker:	Worker function
+ *
+ * Initialize work which is automatically cancelled when driver is detached.
+ * A few drivers need to queue work which must be cancelled before driver
+ * is detached to avoid accessing removed resources.
+ * devm_work_autocancel() can be used to omit the explicit
+ * cancelleation when driver is detached.
+ */
+static inline int devm_work_autocancel(struct device *dev,
+				       struct work_struct *w,
+				       work_func_t worker)
+{
+	INIT_WORK(w, worker);
+	return devm_add_action(dev, devm_work_drop, w);
+}
+
 #endif
-- 
2.53.0



