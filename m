Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EB02620C9;
	Thu, 17 Apr 2025 18:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914381; cv=none; b=rW3sZ1Fs6dpxrRT6Fi2Zmc0n2bR1WznsBXLJ6AZ/a3ifN7H9keHg2jUgyVvWr2Fl1KfbgETgd0iBNvtoz3gTblnVtPz8VjeiCu4LRvlfWExv1LsDUArA8y8GO9VptLQDlE5GlnuRdXlC9FpCp3UiRT8VrJ+IEg4vnmIdfvcolRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914381; c=relaxed/simple;
	bh=EJOOdHBhz4hjLRwTje9Ru1ApcXS3rOYu1YWowPuxfgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOI061DUite0dg8342TnNBaMHdhcy98B/hS93LXgjjBdfIi5VpHkCNlal01uS61fBJqdKmHMY62SfhEbOqOC9JnImoh/9m27hi5OlskEnDaEZUAk4w7OQ5SpDFIaQzprQa9qckvMEY5JbbTOWOOj1dM7Wibe53eSsFId8mpPWcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6rkrib+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6rkrib+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3498DC4CEE7;
	Thu, 17 Apr 2025 18:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914381;
	bh=EJOOdHBhz4hjLRwTje9Ru1ApcXS3rOYu1YWowPuxfgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6rkrib+Jt1/29GDDb0dXU+EWTOO9mud8AoEd2536F5sUAHRt5kG7ejYgd0h5/SHL
	 DZ30Y/JYktHLendvjfMiIYupyh8oTOsz/cSKcyjFt1qLyWu+DeUz+okIrzv1sx40ad
	 5fze2GlQ5T/oJ/R/aNSpS2b+b7SYMBTpSzZMCUE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 196/414] dt-bindings: media: st,stmipid02: correct lane-polarities maxItems
Date: Thu, 17 Apr 2025 19:49:14 +0200
Message-ID: <20250417175119.326024666@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

commit 3a544a39e0a4c492e3026dfbed018321d2bd6caa upstream.

The MIPID02 can use up to 2 data lanes which leads to having a maximum
item number of 3 for the lane-polarities since this also contains the
clock lane.

CC: stable@vger.kernel.org
Fixes: c2741cbe7f8a ("dt-bindings: media: st,stmipid02: Convert the text bindings to YAML")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/i2c/st,st-mipid02.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.yaml
@@ -71,7 +71,7 @@ properties:
                 description:
                   Any lane can be inverted or not.
                 minItems: 1
-                maxItems: 2
+                maxItems: 3
 
             required:
               - data-lanes


