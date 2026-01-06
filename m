Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C12224B15;
	Tue,  6 Jan 2026 17:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721600; cv=none; b=MEREuzHg/oYCHOvWKyHim2YYx7BS6g8y4+8A5zE6mc5oAMXq+8LuLAu4f5cgI3veHQjYPIUSl/hb/IMmQPAE+Q00tsn6z8idSyg3QzvsHZ7SoGcYvCxJJ+bmde+jjb3fk4HfgOHQBAgY9WR/vONAmPI1on9kL9NL3frhMW7Y4hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721600; c=relaxed/simple;
	bh=7KlFOj2H1Muak6/stiqHPnXb355GcSoD/Qq7p+bZYQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZl6fnMIHwXaYDIlwkCY3IJ3UsDTZmoBUcbkwfE2WiN0NOrk2UN/AiWAcqnaUbRPBoVkWc+Lm9Q9NJ+q6rXQxjbqUP9ZDvy7V474rNO1R6ah/pqShjrBELj0hK9POcxgXQNkSOsQkfJ40mDdkM2XAENK6jpTajyKJs0hPp4/8UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVA4lri2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVA4lri2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D955C116C6;
	Tue,  6 Jan 2026 17:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721600;
	bh=7KlFOj2H1Muak6/stiqHPnXb355GcSoD/Qq7p+bZYQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVA4lri2WQ5wN3Rtf523D7SXLb5oFlH57EyZDy3YPuwp4qge2fRGMSOcf/3G+nHLB
	 mgN2A3cRhjGhhsCsrbm7aiJFItPWsZBcKoOAxfSvAdNdLjkRk7kgVLJ8CM8/amJLuf
	 2hO9IJFLa/7DJJE3KzXfCUJy3scRtrmvX8LoE0uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH 6.18 002/312] drm: nova: depend on CONFIG_64BIT
Date: Tue,  6 Jan 2026 18:01:16 +0100
Message-ID: <20260106170547.928444007@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit ba1b40ed0e34bab597fd90d4c4e9f7397f878c8f upstream.

nova-core already depends on CONFIG_64BIT, hence also depend on
CONFIG_64BIT for nova-drm.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Link: https://patch.msgid.link/20251028110058.340320-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nova/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nova/Kconfig
+++ b/drivers/gpu/drm/nova/Kconfig
@@ -1,5 +1,6 @@
 config DRM_NOVA
 	tristate "Nova DRM driver"
+	depends on 64BIT
 	depends on DRM=y
 	depends on PCI
 	depends on RUST


