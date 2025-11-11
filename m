Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810812C026E;
	Tue, 11 Nov 2025 01:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824537; cv=none; b=mnimAR1lymhHfp94xwlsLD9X/sgLvUuVzqZ55wy/o6r7Xz6mV6/yoWIbvO6zM38hh9yy8edpHm0f0raWM+HCc/fhAi0Ds4dVEXSMipR5+2MzHgErg+ccOREeofF9GnttawWZ0SJylhhd8r+xay5ml6dQ9uM6EFbKsGXfKFKoKLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824537; c=relaxed/simple;
	bh=bNHQf0yUCBR+UWsTokEj2QuEg+HZVW9iArn/H97gb+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjoYhdgrihub/j5KFCqoJxfjwCU0eq3DkRs3xFOAKnTmGmP2/DI//NbMYceEH8cIIm+rx/63FTIiDFFV3/dgbDSJspr/109ITyJlrzqg4GtBiZZ6S+VUY8RNxFzxlKqj33AZTi+4O8MFJDNLCigIPeuQLkX32+fo48Gv+SE6Kys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrpODjTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrpODjTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1501AC113D0;
	Tue, 11 Nov 2025 01:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824537;
	bh=bNHQf0yUCBR+UWsTokEj2QuEg+HZVW9iArn/H97gb+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrpODjTFAJtnWjJni8CaUnDSqa+jQRZRaByFyUL49CXke9SnUEtJ1xLMn0uvjWPj1
	 pJMV5qk9AUSvcXO+oxjzX2wLXsPl3JnCarA2BSQA4Huj5Adq37G7FHCksLnKQQprEM
	 cYjNPY0nPtet+EgG08Ul+KifNL3f8xKm7JVvu6Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 465/565] um: Fix help message for ssl-non-raw
Date: Tue, 11 Nov 2025 09:45:21 +0900
Message-ID: <20251111004537.361482178@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 725e9d81868fcedaeef775948e699955b01631ae ]

Add the missing option name in the help message. Additionally,
switch to __uml_help(), because this is a global option rather
than a per-channel option.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ssl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 277cea3d30eb5..8006a5bd578c2 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -199,4 +199,7 @@ static int ssl_non_raw_setup(char *str)
 	return 1;
 }
 __setup("ssl-non-raw", ssl_non_raw_setup);
-__channel_help(ssl_non_raw_setup, "set serial lines to non-raw mode");
+__uml_help(ssl_non_raw_setup,
+"ssl-non-raw\n"
+"    Set serial lines to non-raw mode.\n\n"
+);
-- 
2.51.0



