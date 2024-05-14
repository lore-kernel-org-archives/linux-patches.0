Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BC06BFAC;
	Tue, 14 May 2024 10:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683776; cv=none; b=cyuwgopAtVBuGck323gA1sBwCoKxZpxGUfquG1cm3lxWfCj89FC8AO08D61klZoWameiE2NBPDi5EmDG6ZeEOMJnpO1j7rOhi5br+2gWTExvXd7YLRTQlBvXzUodWqDGq7I6++NGX3npyyiiFX2Yy1A2/cV4tdAihIsYNzqb/uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683776; c=relaxed/simple;
	bh=xY9W55N6Xg0lETEK6D9S8pNO6lErS6AVDXTWx5T0TVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUEnN3cdQOD1HTRcXg4QWu6Jb6qPD2C+jbb+1cXrbhDNFMFIb+xrhXKbx36a3u2m+NxycL+5ERsaWahxDS/RvKh4IWZ/C601FKgv16LsxZwk2a+mChaQ6Dg7Ww4ato2LaoJ+LZtJxp1fGqySP8mj5UWALbm141GbtvBh8E+8bv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAlYi0CD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAlYi0CD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A750C2BD10;
	Tue, 14 May 2024 10:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683776;
	bh=xY9W55N6Xg0lETEK6D9S8pNO6lErS6AVDXTWx5T0TVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAlYi0CDbctsO6BxVM5zIj2r31I91AE24xg9696YRlDF474F6TQ1tsih6dGYih2N9
	 8erypsfniG12OAhnnmwb929vMl8pGE82q3gZhvMHeaQz5+V4T5kkNnYsrMYul7ggBt
	 6RzIKVKgfQtyuerWpOe1R33AMP8mxWOEEfTKLda8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.8 272/336] dt-bindings: iio: health: maxim,max30102: fix compatible check
Date: Tue, 14 May 2024 12:17:56 +0200
Message-ID: <20240514101048.891105356@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 89384a2b656b9dace4c965432a209d5c9c3a2a6f upstream.

The "maxim,green-led-current-microamp" property is only available for
the max30105 part (it provides an extra green LED), and must be set to
false for the max30102 part.

Instead, the max30100 part has been used for that, which is not
supported by this binding (it has its own binding).

This error was introduced during the txt to yaml conversion.

Fixes: 5a6a65b11e3a ("dt-bindings:iio:health:maxim,max30102: txt to yaml conversion")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20240316-max30102_binding_fix-v1-1-e8e58f69ef8a@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/health/maxim,max30102.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/iio/health/maxim,max30102.yaml
+++ b/Documentation/devicetree/bindings/iio/health/maxim,max30102.yaml
@@ -42,7 +42,7 @@ allOf:
       properties:
         compatible:
           contains:
-            const: maxim,max30100
+            const: maxim,max30102
     then:
       properties:
         maxim,green-led-current-microamp: false


