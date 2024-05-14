Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42479F9D4;
	Tue, 14 May 2024 11:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687922; cv=none; b=Y6bjUDMWEiuOlMOTwPWtItE7lf1Y7egP/17vfpTtw3nf3/4EYseCf7rl4Lm2jdZOvg+wdBrUrXu2/eWnwbp3xlO6cmJMMP6uNfp3NJJ2lRwr7Viuen5X741KXzGJkVrBQ6oWGuaW9qWc1Dg50DlJ+RUs9MS8M4fOGkXxcycD6tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687922; c=relaxed/simple;
	bh=T57ZUUwVieO+cW0PnZlpe0MtS40jH5klGzmHWSWOn78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAaPKpy7vYhYcWj+FOUrhVnekqGUvAcY2FxgwKK3yQM0i66aFZYzS21t7mdrfD9x/bL+o+I07j0HFcMjg6zLojBPFbNRKqc6rOGst+ALx54rpOAGbqGe4EVNYE+2Hq4aJnQ8WiNa3KJmciYp8siqaYUgQKCeOkfPp9/iIKq0G7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPmQTzQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPmQTzQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4999C2BD10;
	Tue, 14 May 2024 11:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687922;
	bh=T57ZUUwVieO+cW0PnZlpe0MtS40jH5klGzmHWSWOn78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPmQTzQWAlZS8JuqgfYDSv8YchXmXWuTRbzWUGdJUZQf5m5qc8CW1Dp+fnuSrR1w0
	 bv/kq2NPcQz/IkdLWFMwpih8BrbhzrC+T1MvXScY/Fm04pZs81tQaVnFYzlVlhfWwu
	 0fHRhFVFtmdaurz8e0/hGGvxegW/O/uCgAA7Z0rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 152/168] dt-bindings: iio: health: maxim,max30102: fix compatible check
Date: Tue, 14 May 2024 12:20:50 +0200
Message-ID: <20240514101012.498371800@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


