Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061922;
	b=Hp8A/AvWnmM2lPa8QeauSRRPSEytorLrwUyWo2E4KXpkT80O6WXEm4vrlCECdGFQz3ek
	 gkP/uU1ow/lR7EUbYKeG4Vt+A7S5e2iw42qxAu/NkOuvOqdvHfxSd0poDo4qvEil9pnri
	 OFB6JASaovobPiYJr0r+p9REKQHKsW820W2M9IQTPNHgTbXqrz2QKOe8GLq6RQ7RVn0Mm
	 AJd2FzuKDnNIoNWPX9CokuT7TfhG1JjgExs4xbDrMocxZ1OcBMYQd0mltL+pSkjyK4hS3
	 shN33Q99IZgRdl94TTuMEx5SPEbKcCc3suqkrrAKqhxhaH0eAjYuDlOnUE5iLH02kVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FRbyUR9zZwqgoQ+eswsGX0Slhwmafu1ICrQ2ptjv1sM=;
	b=HSmC3z1wQ5ZMoV6HOnJZ1o26psFDB4ksvBVjqUjIbNMir81CDIoIk/82+IOwcwCoC4sS
	 wzoIKH+i1lyqd4ErVawJ1WdLGn6SvbL6/1JSldK+JEBuoPbRdxEvTdEfaoJeDfbnb3iZZ
	 l6SaCmUAdn5eAS2kCJViyYiaF4gu655dROsUf/Zen/juk/45Wv2Bj2+kM55yzJS8TjmEH
	 28NCE4CXZFPxxWQumP6YbbPS0j5QS+xRBrk7MsoEEIEBMMI00+93WHZwbaSf08ATJp3ri
	 H7ApGY6ozFYm7SwLf8nJuIIw6mNswzcH9wd1EHgzEKS/cHA5+3Cmv6R18RYl12XlHpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1X5K1Fn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AB4606A335;
	Sat,  7 Nov 2026 14:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1X5K1Fn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117D61F0089F;
	Sat,  7 Nov 2026 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061922;
	bh=FRbyUR9zZwqgoQ+eswsGX0Slhwmafu1ICrQ2ptjv1sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1X5K1FnXIUYjmldToSBAKJoYuJKTYsZePw9tbZr4voZwbeEuPSm5ZtBPe2H+9E7v
	 Sq/AqGAfEK4vlxq3JLcJiErUBoTdHui+SV2ZRf7q3ArJA+EbsOCFmROhQmSHVkgFpZ
	 eTJ9GnPZvLPbLEOc73pxqAnzld3kOlPCeEwfZjvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0928/1536] thermal: intel: int340x: Fix temperature selection around 0 C
Date: Sat,  7 Nov 2026 08:49:04 -0500
Message-ID: <20261107135023.713802885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit e56e2b49c67d132728e52ce493079e83cc914657 ]

Since commit 7251b9e8a007 ("thermal/intel: Fix intel_tcc_get_temp() to
support negative CPU temperature"), intel_tcc_get_temp() can report
negative temperatures.

proc_thermal_get_zone_temp() still uses *temp as the current maximum and
as an implicit "no reading yet" marker. However, this breaks when a CPU
reports 0 C, because a subsequent negative reading can overwrite it.

Use bool temp_valid to track whether a valid temperature has been read.
Initialize *temp with the first valid reading and only update it with
warmer readings.

Fixes: 7251b9e8a007 ("thermal/intel: Fix intel_tcc_get_temp() to support negative CPU temperature")
Cc: 6.3+ <stable@vger.kernel.org> # 6.3+
Signed-off-by: Thorsten Blum <blum@kernel.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260826153144.299746-3-blum@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/processor_thermal_device.c   | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index 7c46dd6bee731..8296f6907d42c 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -177,17 +177,21 @@ static int proc_thermal_get_zone_temp(struct thermal_zone_device *zone,
 {
 	int cpu;
 	int curr_temp, ret;
-
-	*temp = 0;
+	bool temp_valid = false;
 
 	for_each_online_cpu(cpu) {
 		ret = intel_tcc_get_temp(cpu, &curr_temp, false);
 		if (ret < 0)
 			return ret;
-		if (!*temp || curr_temp > *temp)
+		if (!temp_valid || curr_temp > *temp) {
 			*temp = curr_temp;
+			temp_valid = true;
+		}
 	}
 
+	if (!temp_valid)
+		return -ENODATA;
+
 	*temp *= 1000;
 
 	return 0;
-- 
2.53.0



