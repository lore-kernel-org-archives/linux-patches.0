Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9552028DA1
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 23:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; dkim=none
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: sam@gentoo.org,stable@vger.kernel.org
Cc: djakov@kernel.org,gregkh@linuxfoundation.org,holger@applied-asynchrony.com,konrad.dybcio@linaro.org,mgorny@gentoo.org,patches@lists.linux.dev,sashal@kernel.org,stable@vger.kernel.org
Subject: Re: [PATCH 5.10 137/191] interconnect: qcom: sc7180: Set ACV
 enable_mask
In-Reply-To: <87fs10k1ee.fsf@gentoo.org>
Date: Fri, 24 Nov 2023 23:01:17 +0000
Organization: Gentoo
Message-ID: <87wmu6oiwe.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Could a revert be queued for the next 5.10.x please?

thanks,
sam
