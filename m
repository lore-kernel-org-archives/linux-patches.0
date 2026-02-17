Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7317D284B3B;
	Tue, 17 Feb 2026 20:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361419; cv=none; b=VAoil2RHeU/Vpk/4BYjWHWafpnGJgHL7aON/QmHrXB6i/vrBr5j9NQPU6/vaVojovdtcCho5dL2vRHk1k6VQ+nO6+F9P3pARntcHGiikqYpA7VduKE82uJKO656++Hc78lAHoo3+ZYHJ5je4pRRZ/awpuYS2NrwZAH6UyjqjWnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361419; c=relaxed/simple;
	bh=o0Nzo3SKQVDZW0IWnO7aO0O9IdpieR78wox3IByApx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfRpexBzb8TnjVzxZUXHK6/Pp7aKzrT9YgUmGkRmmRpWTmX3v/cXlq4JhPeSmTHHrrYDxlkplzzsIy0RKBdkGAs3TrC47BOnOHKeWRD2UaHzNp28GKRadVAQsn0dmrX5SoeAtdklz9YZLkMHbtkX/7xygsclkd0uKOtb0V5oSEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFtnRCxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFtnRCxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF512C4CEF7;
	Tue, 17 Feb 2026 20:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361419;
	bh=o0Nzo3SKQVDZW0IWnO7aO0O9IdpieR78wox3IByApx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFtnRCxo6nBp8XyZ01ezftE8u/t1x1D0TsZ1OZSeU3kpsUV5Vx+e/hJoBE5kW1A16
	 F3dY3sYgWReKnBcJKNpEOV9Tmlu7D93fscF7qckNFiAQlfH/5K01csuI9wuarrvf7h
	 0ec+etvv9RzO8ceezscJZquqkNviHpFAKRWZ6gx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <listout@listout.xyz>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=206=2E18=2011/43=5D=20=3D=3FUTF-8=3Fq=3Fdrm/tegra=3A=3D20hdmi=3A=3D20sor=3A=3D20Fix=3D20error=3A=3D20variable=3D20=3F=3D=20=3D=3FUTF-8=3Fq=3F=3DE2=3D80=3D98j=3DE2=3D80=3D99=3D20set=3D20but=3D20not=3D20used=3F=3D?=
Date: Tue, 17 Feb 2026 21:31:51 +0100
Message-ID: <20260217200006.902883520@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <listout@listout.xyz>

[ Upstream commit 1beee8d0c263b3e239c8d6616e4f8bb700bed658 ]

The variable j is set, however never used in or outside the loop, thus
resulting in dead code.
Building with GCC 16 results in a build error due to
-Werror=unused-but-set-variable= enabled by default.
This patch clean up the dead code and fixes the build error.

Example build log:
drivers/gpu/drm/tegra/sor.c:1867:19: error: variable ‘j’ set but not used [-Werror=unused-but-set-variable=]
 1867 |         size_t i, j;
      |                   ^

Signed-off-by: Brahmajit Das <listout@listout.xyz>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250901212020.3757519-1-listout@listout.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/hdmi.c | 4 ++--
 drivers/gpu/drm/tegra/sor.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 8cd2969e7d4bf..c4820f5e76581 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -658,7 +658,7 @@ static void tegra_hdmi_write_infopack(struct tegra_hdmi *hdmi, const void *data,
 {
 	const u8 *ptr = data;
 	unsigned long offset;
-	size_t i, j;
+	size_t i;
 	u32 value;
 
 	switch (ptr[0]) {
@@ -691,7 +691,7 @@ static void tegra_hdmi_write_infopack(struct tegra_hdmi *hdmi, const void *data,
 	 * - subpack_low: bytes 0 - 3
 	 * - subpack_high: bytes 4 - 6 (with byte 7 padded to 0x00)
 	 */
-	for (i = 3, j = 0; i < size; i += 7, j += 8) {
+	for (i = 3; i < size; i += 7) {
 		size_t rem = size - i, num = min_t(size_t, rem, 4);
 
 		value = tegra_hdmi_subpack(&ptr[i], num);
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 21f3dfdcc5c95..bc7dd562cf6b6 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -1864,7 +1864,7 @@ static void tegra_sor_hdmi_write_infopack(struct tegra_sor *sor,
 {
 	const u8 *ptr = data;
 	unsigned long offset;
-	size_t i, j;
+	size_t i;
 	u32 value;
 
 	switch (ptr[0]) {
@@ -1897,7 +1897,7 @@ static void tegra_sor_hdmi_write_infopack(struct tegra_sor *sor,
 	 * - subpack_low: bytes 0 - 3
 	 * - subpack_high: bytes 4 - 6 (with byte 7 padded to 0x00)
 	 */
-	for (i = 3, j = 0; i < size; i += 7, j += 8) {
+	for (i = 3; i < size; i += 7) {
 		size_t rem = size - i, num = min_t(size_t, rem, 4);
 
 		value = tegra_sor_hdmi_subpack(&ptr[i], num);
-- 
2.51.0



