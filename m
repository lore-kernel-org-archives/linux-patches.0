Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061389;
	b=ty2jIXnIMuk4Rxat6CcvNbP7SbGYbvLzFYX3pJBVxJPfpxoRR7ZNPWVPsK98XWkq5+Xt
	 IDKYUbcOzdtYSXe1P26OAJMocH31qfDaXlTjjeKF845GOuVtGVtA1egaqRWiWoq6hb49p
	 ciOVvYR7XbKzLrPTUealW0GK14kWj94Gvqy4muOY9vnQuYNqIN8MiqDcjFvMW2w8NAtek
	 emlr9eakXeE8cqXma0utRmNprZnuoC9T8gNjdk8f9NlsiloUxE5uOn1xjTuGeB2pk4cUz
	 RbgSHWimZEOqpdVzSZI1YVtX92vgYaFZNWzcIHoWrGJjQmyBbwIFNEJBq2u1LgRf5rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=avrsKcEBSWFsRowGbkWFGFBOXhfwlrW/xIWYBxQw5OA=;
	b=AN6S3q0iUvEBQarLKu3bdEpISIaPmVTHHVfd/qRboqyFMbnY2JMAZQm+4vtdyKQ7+eEa
	 oUNm2VSOC6vnaCqP2phNAisVsJ2eG+Wv/DVaADItAwluMexVlj00st2XRS844uT6gev1t
	 KOE6Nr1CBO2Da/KfuvhvcGPHbF4gETWa/wJ70VsfvBsXH2OKqpWCCghrC6envipoNFZk0
	 v+BnTLgwWQMXMO1E/Duv8iACSoGqvhZEjkkNdluPy/PZI0yZDpjsDr+t+e1lnanEfXGuz
	 JLzuWicSqN6iGvYe+rZ2tUJ8hzwsCIYXWvDXLf8WV6qmQncR81n5B96hmThbyuczYFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mAsFCCl/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CD0606A32A;
	Thu, 19 Nov 2026 04:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAsFCCl/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138DC1F000C4;
	Thu, 19 Nov 2026 04:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061388;
	bh=avrsKcEBSWFsRowGbkWFGFBOXhfwlrW/xIWYBxQw5OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAsFCCl/QZ0dH7BCTYIrLhj2fjwxrlxAfcpjJ+jAA6EnGt9vC9DUGW1KM0kPxy77m
	 aP7GNzFpT6jl+/m1mQx2RVc1mNpVyIQHu9Yotcw8BSjZE/yum9RzLhLXQsWSTDtS38
	 4yVYOMvXtU3wcEeUYUtIpyToXdj/y46Rjlhm6mqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1535/1848] PCI/sysfs: Rely on lengths from scnprintf(), dsm_label_utf16s_to_utf8s()
Date: Wed, 18 Nov 2026 15:59:33 +0100
Message-ID: <20261118150023.780039561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kw@linux.com>

[ Upstream commit 316ae33051215f92c72fe13bc1bfc4e513a26700 ]

scnprintf() returns the number of bytes written into the buffer.  Change
dsm_label_utf16s_to_utf8s() to do the same.  Rely on those values instead
of using strlen() to compute the buffer length.

No functional change intended.

[bhelgaas: reorder patch in series, len++ to include newline added by
dsm_label_utf16s_to_utf8s(), commit log]
Link: https://lore.kernel.org/r/20210603000112.703037-3-kw@linux.com
Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Stable-dep-of: 36f9bd09920e ("PCI/sysfs: Stop reporting _DSM failures as -EPERM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-label.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index c702164d4ad1a..5b59b1870f3f0 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -154,14 +154,17 @@ enum acpi_attr_enum {
 	ACPI_ATTR_INDEX_SHOW,
 };
 
-static void dsm_label_utf16s_to_utf8s(union acpi_object *obj, char *buf)
+static int dsm_label_utf16s_to_utf8s(union acpi_object *obj, char *buf)
 {
 	int len;
+
 	len = utf16s_to_utf8s((const wchar_t *)obj->buffer.pointer,
 			      obj->buffer.length / sizeof(wchar_t),
 			      UTF16_LITTLE_ENDIAN,
 			      buf, PAGE_SIZE - 1);
-	buf[len] = '\n';
+	buf[len++] = '\n';
+
+	return len;
 }
 
 static int dsm_get_label(struct device *dev, char *buf,
@@ -169,7 +172,7 @@ static int dsm_get_label(struct device *dev, char *buf,
 {
 	acpi_handle handle;
 	union acpi_object *obj, *tmp;
-	int len = -1;
+	int len = 0;
 
 	handle = ACPI_HANDLE(dev);
 	if (!handle)
@@ -191,20 +194,19 @@ static int dsm_get_label(struct device *dev, char *buf,
 		 * this entry must return a null string.
 		 */
 		if (attr == ACPI_ATTR_INDEX_SHOW) {
-			scnprintf(buf, PAGE_SIZE, "%llu\n", tmp->integer.value);
+			len = scnprintf(buf, PAGE_SIZE, "%llu\n", tmp->integer.value);
 		} else if (attr == ACPI_ATTR_LABEL_SHOW) {
 			if (tmp[1].type == ACPI_TYPE_STRING)
-				scnprintf(buf, PAGE_SIZE, "%s\n",
+				len = scnprintf(buf, PAGE_SIZE, "%s\n",
 					  tmp[1].string.pointer);
 			else if (tmp[1].type == ACPI_TYPE_BUFFER)
-				dsm_label_utf16s_to_utf8s(tmp + 1, buf);
+				len = dsm_label_utf16s_to_utf8s(tmp + 1, buf);
 		}
-		len = strlen(buf) > 0 ? strlen(buf) : -1;
 	}
 
 	ACPI_FREE(obj);
 
-	return len;
+	return len > 0 ? len : -1;
 }
 
 static bool device_has_dsm(struct device *dev)
-- 
2.53.0



