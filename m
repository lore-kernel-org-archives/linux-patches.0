Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C85523AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDE6C433D2;
	Wed, 28 Dec 2022 16:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246676;
	bh=Q78Q/N8a6EdC1mmS50c7z2Q4OJhKO6FyuPTE8rhZRsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oK2jOz4FatOFLqk2ncwgBfyZ61OIcECeWIeNwOR5RwV5hNMKUYjsbEuPa0E3y8+GC
	 b9EnNy+SOAZVUYATJEuyGo/HefWNV8GEcGrR7zIgeS0nPq+yBTSK6LIxtk6P4QlOLO
	 ihD4TGQ+XOqOFdn1XxV7D9gZJ2FcCRbYNbg6j9U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Rob Herring <robh@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1095/1146] dt-bindings: input: iqs7222: Reduce linux,code to optional
Date: Wed, 28 Dec 2022 15:43:54 +0100
Message-Id: <20221228144359.915597858@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit ccad486525c49df2fe2e7090990522547dfd2785 ]

Following a recent refactor of the driver to properly drop unused
device nodes, the 'linux,code' property is now optional. This can
be useful for applications that define GPIO-mapped events that do
not correspond to any keycode.

Fixes: 44dc42d254bf ("dt-bindings: input: Add bindings for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/Y1SROIrrC1LwX0Sd@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
index 02e605fac408..b4eb650dbcb8 100644
--- a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
+++ b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
@@ -473,9 +473,6 @@ patternProperties:
               Specifies whether the event is to be interpreted as a key (1)
               or a switch (5).
 
-        required:
-          - linux,code
-
         additionalProperties: false
 
     dependencies:
@@ -620,9 +617,6 @@ patternProperties:
               GPIO, they must all be of the same type (proximity, touch or
               slider gesture).
 
-        required:
-          - linux,code
-
         additionalProperties: false
 
     required:
-- 
2.35.1



