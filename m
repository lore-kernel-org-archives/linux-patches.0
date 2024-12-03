Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C791B1DDC26;
	Tue,  3 Dec 2024 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240429; cv=none; b=kOdlnRZHbKI1RMf33+QAzSe5A36/Zd16Hghwe7e8kFWg+G+LpbT5w4uga+KkL2hoVxdckcGiaA1JYD0dod9J6/BETjLAVp02XnI9kP1PyhU+6LRCxo6qWkvDqHG2s3HfT8TiaR0A+jLwyAKTJwl//d0zAYd+XOckaGrtEoM7ZgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240429; c=relaxed/simple;
	bh=mr35+k15UdQV67AjyJCFOIzYWVOzeZd6NujJrIeRZoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YECWAnf5UfrE7b9lBkvLwC0gh5AofHPtOE+UEwNILDoD7hJc4qNV2k1AwXrXZ9V+cUx4D2j6KJRkqju2lW2glh7UQNAU76tgSL7bZ+L+osC6RtDN3rcFEgb6b+Kmx1fdvWxSCL3O6mg8KIA653lLLTiecX7kFeIeYENZ+wj3OYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gf3Y7Jno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gf3Y7Jno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50071C4CED8;
	Tue,  3 Dec 2024 15:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240429;
	bh=mr35+k15UdQV67AjyJCFOIzYWVOzeZd6NujJrIeRZoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gf3Y7Jno+RBz8unKHJcMV9njXQsZCPzNGxm53tP1N/Cbnx4boIC9TgjpgCcaxF7zU
	 roxLjCGnd6yF3ntaeBoYT/vI6rQqLzlv0Z9dyZ/NPxe9Aha56ZGbkD0wJOUgUmHZWx
	 2kC3QcHwHmrEQpt9B078h3w1B5Fiyv9X1SCALnIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/826] gpio: sloppy-logic-analyzer remove reference to rcu_momentary_dyntick_idle()
Date: Tue,  3 Dec 2024 15:37:38 +0100
Message-ID: <20241203144748.851733836@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srikar Dronamraju <srikar@linux.ibm.com>

[ Upstream commit a0b6594e411dcae0cc563f5157cf062e93603388 ]

There is one last reference to rcu_momentary_dyntick_idle() after
commit 32a9f26e5e26 ("rcu: Rename rcu_momentary_dyntick_idle() into
rcu_momentary_eqs()")

Rename it for consistency.

Fixes: 32a9f26e5e26 ("rcu: Rename rcu_momentary_dyntick_idle() into rcu_momentary_eqs()")
Signed-off-by: Srikar Dronamraju <srikar@linux.ibm.com>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20240925054619.568209-1-srikar@linux.ibm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/gpio/gpio-sloppy-logic-analyzer.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/gpio/gpio-sloppy-logic-analyzer.sh b/tools/gpio/gpio-sloppy-logic-analyzer.sh
index ed21a110df5e5..3ef2278e49f91 100755
--- a/tools/gpio/gpio-sloppy-logic-analyzer.sh
+++ b/tools/gpio/gpio-sloppy-logic-analyzer.sh
@@ -113,7 +113,7 @@ init_cpu()
 		taskset -p "$newmask" "$p" || continue
 	done 2>/dev/null >/dev/null
 
-	# Big hammer! Working with 'rcu_momentary_dyntick_idle()' for a more fine-grained solution
+	# Big hammer! Working with 'rcu_momentary_eqs()' for a more fine-grained solution
 	# still printed warnings. Same for re-enabling the stall detector after sampling.
 	echo 1 > /sys/module/rcupdate/parameters/rcu_cpu_stall_suppress
 
-- 
2.43.0



