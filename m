Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044064;
	b=BW1QyjMwDQVj6vQUccHKwiHtbiYFbiDLe585Ua6brH1CsMdar+QQYLHqOQrj9JvgUFt9
	 5Gh9ie6hDdtqIJgWPZRe2+04UAGRj52droJDQu+4yKETZx2rE4kiYBSQn/kLuHMEn5y1a
	 bqIlMTJn8S8dgRgmZvGL6F3zGkw8XgDQdSHOi4AhC9kokjHdepx5a4JKMgyz4WecemQof
	 CA6Hp7yUjxftEuLpfbgF2G6mg3H/NrSNO56oK5gMYtKIX4qzZrgPaiC//7n6WpPW9eC+/
	 MTsTGUVy9+UDe2qRRBKG4jkCWc0l02PxFN+iTM+vIk4ri+5nqPUGNmpgPS/ZmOn+GHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t5yBbC4sctcuN6+C6ABTzzoRr6GzwaXrLMuAXgByQ7o=;
	b=24NTAFH2eYbCqRweA5yQSyrQQ70bDIPYA8HiK4a1XPxg4sgyfX7zFhj40+obA1LiGkaV
	 sWuY+rE6uv7KicENyCXOfUXOm0PVXVC8dG1GELCHBCOMoBo24lf2mlUQw1em8+uw/xEh4
	 MmiUrDDYXaApL4ugpAs8VKzGxIWpOp45BzZfCM9FBbLO1NvE6rcC1re+oDToYRX0ddFKH
	 /ALx1lsjQ+VDym06+NhyHYAr8KJ+C+h81QBUgDzhOV0AlEpfKOBl5Skr8Y9bus5w1fjE4
	 GM0dGeumAnCPbMVGJ0hQUObOCQU/2xM1YI18G7XmZbMYWzRXghsdUDdpMcw4RYA1aAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2R05lx17;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C331606A31C;
	Wed, 18 Nov 2026 23:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2R05lx17
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBD21F000C4;
	Wed, 18 Nov 2026 23:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044064;
	bh=t5yBbC4sctcuN6+C6ABTzzoRr6GzwaXrLMuAXgByQ7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2R05lx17SrGv84QIl5NeXIKX6Q6JOHaVX9beiYb17/6NFr36kgTAu8EfCRP5yTBnE
	 wuMFt5h1yNl1Bkb81dx/en/saF1cioX3cwgeraFBZd/dXicYT0uoEOUTEgZpUYujIS
	 TkgfYl/bzDpHfRamxOt1ZyqWcKukiEmr1jlACrmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0434/2857] i2c: imx: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:24:28 +0100
Message-ID: <20261118150217.008565166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit e0c3e9d76adbe522dd420a766ce42d03ce887c29 ]

i2c_imx_probe() enables runtime PM autosuspend with
pm_runtime_use_autosuspend(). The probe error path correctly undoes
this setting with pm_runtime_dont_use_autosuspend(), but the normal
remove path only disables runtime PM.

The runtime PM API requires pm_runtime_use_autosuspend() to be undone
with pm_runtime_dont_use_autosuspend() at driver exit unless runtime PM
was enabled with devm_pm_runtime_enable(). Leaving the autosuspend flag
set therefore leaves the runtime PM state incompletely cleaned up after
the driver is unbound.

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: 588eb93ea49f ("i2c: imx: add runtime pm support to improve the performance")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: <stable@vger.kernel.org> # v4.5+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260914091544.1667137-1-lgs201920130244@gmail.com
[ sashal: adjusted the hunk context because i2c_imx_remove() still returns int, so the new call sits before the existing return 0; instead of the closing brace. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 41030f0ff7801..9018160e70fa1 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1660,6 +1660,7 @@ static int i2c_imx_remove(struct platform_device *pdev)
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 
 	return 0;
 }
-- 
2.53.0



