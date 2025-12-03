Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EEA3AA195;
	Wed,  3 Dec 2025 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779612; cv=none; b=c0YdEoLstMEvSfYa4AwnAS2UHm8V0SWZOZleD7hbQNiG67UK4p4ZH4hEGxoJ2FKqwy4Kz62wWk0tpCVfhQJz3Rbr/YRats1gHiXAEynFdiCnKVwZQb5SdtVxMPJcYx2vpy3hPFNuHUMJyaZhfbiqqSVw0JEQPFIRd3YRe4dhyIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779612; c=relaxed/simple;
	bh=f0moPgJyPpBhHND50mLSCHl+HrhAiY9tEmaj90TPVfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJltx6YDsMjvxvPGPyLu11A5J9i40cl07GGDPbHDpil0l8maFIL283KD6LH0TF93NEBGyrPajtnntj1ufoeE22p+RVB0zkWQTvpyfuxl+P8YrEPJwlthvv6YXyjGOV8kgdumlmU6+H92t1oFlAAZBX91YLEw1YYM+sdUBZTwCm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jf80XTUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jf80XTUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5319BC4CEF5;
	Wed,  3 Dec 2025 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779612;
	bh=f0moPgJyPpBhHND50mLSCHl+HrhAiY9tEmaj90TPVfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jf80XTUEq8b5KebmjY3tJDGsvwUL159eBBUBFC0ozWPeI8Tzj7RKijWWgVDR2fQuU
	 Qr/zPqyfSAA31V381K34R+LXw+2UDL1wcnGZRV6aC+tOPXUp5Bbukm5kKNG3NAMQqV
	 9RcRe6PxrUBYbivH033EYXb23ev/+oT3Kkd2mRNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 282/568] um: Fix help message for ssl-non-raw
Date: Wed,  3 Dec 2025 16:24:44 +0100
Message-ID: <20251203152451.035480209@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



