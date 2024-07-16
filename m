Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D9A1DDCE;
	Tue, 16 Jul 2024 16:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146229; cv=none; b=gIQkxtzhvTmhsgmp4bsuf+eEdFF7pSpZvgKTB0fp90dzQ0iuFBCXEne7bZobadxhaDgtOwy06wfxrgQvdPsdhL+rBvzmabSpt2wX01LE1mJvDSR1qqBjMnNqDsvmV9GR7FZggeYY/axX1WG7Tk166DSTMkiwVDOMOrZmD1Bn394=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146229; c=relaxed/simple;
	bh=93MZEOUDlXLcZdH3azQfIUya8gyQ0ICePQEXCYWAcJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNki9+Gota6dD1zoQ0MUrb8nqpVAcO+KtW/QXTn+06eNeNND7BbBM52nEGsWB1uJ8pSldi6IfUsOkPea1nuGW2l0IVa4czsk8YK5+qY14jUYV2GbTS8kj9ZFB2DT5zTkEGpcZI2AsjtgFOeNnNjb9N54IAhA8IXeDmNSVybGv8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fS6oVxzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fS6oVxzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA72C116B1;
	Tue, 16 Jul 2024 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146229;
	bh=93MZEOUDlXLcZdH3azQfIUya8gyQ0ICePQEXCYWAcJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fS6oVxzQrt9RPiBi00BWzKo2GBhSiN+92qt+kbKq7GIi0QseMb33mw8TJ3uXsOyLa
	 vQlKSlUEq8SPUpfFQQzOs/D5mN/jVGE9jV/yA6ca8l7RjdyXpMiBTUCa6vYhbTpK3w
	 SzTdKrIWLdwGNDG8FhdzuSV5NX2Z8iwthGV6lRjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 057/144] drm/amdgpu/atomfirmware: silence UBSAN warning
Date: Tue, 16 Jul 2024 17:32:06 +0200
Message-ID: <20240716152754.739460061@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit d0417264437a8fa05f894cabba5a26715b32d78e upstream.

This is a variable sized array.

Link: https://lists.freedesktop.org/archives/amd-gfx/2024-June/110420.html
Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/atomfirmware.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -701,7 +701,7 @@ struct atom_gpio_pin_lut_v2_1
 {
   struct  atom_common_table_header  table_header;
   /*the real number of this included in the structure is calcualted by using the (whole structure size - the header size)/size of atom_gpio_pin_lut  */
-  struct  atom_gpio_pin_assignment  gpio_pin[8];
+  struct  atom_gpio_pin_assignment  gpio_pin[];
 };
 
 


