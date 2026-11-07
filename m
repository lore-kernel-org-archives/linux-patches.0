Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063876;
	b=a6TRKwNnxenH2UOhFyzRBaiJDJYGTI4h7idnuN6ZuDpA/3fm1AKK84yTLXUpln69CQGw
	 qQREINyV+Hp6UWObYh2H+lAmuyN/OwyozhjnBpu3QlD3x9n0zwK77OehgqWJ0SYH7kpfH
	 h8LlJLUS3OHdUEIg36k+yNNnPh94r7gp8XIuyJUmflqZa7WkobFLsSibaPBfkfV5zGVJA
	 kzx0BwxOXngCvgE9YNWrSHBvyxUVX7i7O58VawtxgLNP3k5Yehvjf8hkX6tO64EsdrHKV
	 gGdUjUihfBjY9gT8bfTCJog1DaVay71AAwC+WxTmPSml/UUrv/V0Kf3BtaxcFYVfDmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g+CzQG44CuNmMW3fbjf7V7k1wwblP6aW+5OrA7/EYSY=;
	b=5fvjxdLf/n4p2Ij0NW1KmBT9dg1j9qGjh2KaT+pvQNa7BdKvsJvvH7m2vw8sVoCkM8i7
	 MWEo3YwZlfITBB6MwY27KsS+y4BDTX8+NzgQ+667UGk/PKlUdVT4V9rteHZJHM69803Ll
	 yiM4k+4HgkYGaadx9EjPF3kSA3VYVfLZ9Y+lFWt5/CUBzRVx3W76h5pqWbYNQbwP6yB4Z
	 rUioK9qZWduzezo0wAehpaVbkqhAqMJAZ9z9m849FoOvVKNT2JO/g+CDF3lxipo+fZIA/
	 2rVD7eF1dG/pwej37JyeTrmCgZH0ROC6e42kNdDBFv7jsW/IyP4mjfY360uOWBS9bGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRgqvVSc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BBD606A339;
	Sat,  7 Nov 2026 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRgqvVSc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E371F008A1;
	Sat,  7 Nov 2026 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063875;
	bh=g+CzQG44CuNmMW3fbjf7V7k1wwblP6aW+5OrA7/EYSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRgqvVScMBd4Ax5aS7MQEHffPTksw0AHHUGtvLEX7hfOhhDjljB66+9WLt7Uu1CsY
	 K8fdbJnKwGT40cXYxWXTitpXTnKlCgYzGmd5km0pjfo2H6gE/jeKNiS28B0e5MRdAJ
	 AvVj6MNgemDog10c3kJJ0HQ8d62XSjE0udHc6+aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0079/1257] thermal: intel: powerclamp: Reject invalid window_size values
Date: Sat,  7 Nov 2026 08:39:35 -0500
Message-ID: <20261107134941.560120980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 40989202104e498ff9adfb8c575d6cd159f13988 ]

window_size_set() sets ret to -EINVAL if new_window_size is outside the
valid range, but then falls through and still updates window_size to the
clamped value.

Return -EINVAL immediately and do not update window_size. Also drop the
now-redundant clamp() call.

Fixes: d6d71ee4a14a ("PM: Introduce Intel PowerClamp Driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260815090136.88540-2-thorsten.blum@linux.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_powerclamp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index bd7fd98dc310e..8026651133d5d 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -289,9 +289,10 @@ static int window_size_set(const char *arg, const struct kernel_param *kp)
 		pr_err("Out of recommended window size %lu, between 2-10\n",
 			new_window_size);
 		ret = -EINVAL;
+		goto exit_win;
 	}
 
-	window_size = clamp(new_window_size, 2ul, 10ul);
+	window_size = new_window_size;
 	smp_mb();
 
 exit_win:
-- 
2.53.0



